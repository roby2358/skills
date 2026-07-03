---
name: yuwakisa_game_factor
description: >-
  Factor a single-file browser game (a yuwakisaweb-style canvas prototype — one big
  index.js of module-level state, an immediate-mode render(), and inline event
  listeners) into a server-portable five-module split: GameArtifacts, GameDisplayArtifacts,
  GameState, GameEngine, GameUI. Use when asked to "factor/refactor this game", split a
  monolithic game into GameEngine/GameState/GameUI, make a prototype "portable to a
  server" or to yuwakisacloud, separate rules from rendering, or add seeded/reproducible
  RNG to a canvas game. Also use when deciding where a new game feature (terrain, skills,
  affixes, locations, combat) belongs across those modules.
---

# Factoring a browser game for server-readiness

Split a monolithic canvas game so the **authoritative half runs headless** and the
browser half is a thin client. The seam is drawn once; the actual client/server wiring is
added later (see Deferred).

## Target modules

Five modules plus unchanged shared libs (`hex.js`/grid math, `rando.js`, `colortheory.js`).
Each new file wraps its definition in an IIFE that returns **one global** (see Globals).

| Module | Global | Holds |
|---|---|---|
| `artifacts.js` | `GameArtifacts` | Static **rules-data** the engine adjudicates over: terrain/unit types, movement/action costs, MP, map dims. No colors, no pixels. Server-side. |
| `displayartifacts.js` | `GameDisplayArtifacts` | Client-only **display attrs**: sizes/geometry, colors, on-screen names, flavor. Keyed off `GameArtifacts` ids, so loads after it. |
| `gamestate.js` | `GameState` | Authoritative, **serializable data only** — `seed`, the grid, units/player, turn, resources, win flags, whose-turn `phase`. No behavior, no DOM, no view/interaction state. |
| `gameengine.js` | `GameEngine` | **Rules + world generation** over a `GameState`. DOM-free and render-free. |
| `gameui.js` | `GameUI` | The **client**: canvas rendering, DOM HUD, camera/pan, hover, selection/targeting/overlay modal state, all input wiring. |

`index.js` becomes a ~4-line bootstrap:
```js
const state  = new GameState();
const engine = new GameEngine(state);
const ui     = new GameUI(engine, document.getElementById('game'));
ui.start();
```

## The invariants that make it portable

These are the point of the exercise — enforce them, don't just move code around.

1. **Engine is DOM-free and render-free.** No `document`/`window`/`canvas`/`ctx`, and
   engine methods never call `render()`. They mutate state and **return an outcome**; the
   UI inspects the outcome and decides what to redraw. Typical shape:
   ```js
   // { ok:false } illegal | { ok:true } | { ok:true, won:true } | { ok:true, endedTurn:true }
   movePlayer(q, r) { ... }
   ```
2. **State is data, not behavior.** `GameState` is a plain bag that would survive
   `JSON.stringify`. View/interaction state (pan offset, hovered hex, current selection,
   targeting, overlays) is **not** game state — it lives on `GameUI`. `phase`
   (whose turn) **is** game state.
3. **Never trust the client.** The engine re-derives legality from its own computation
   (e.g. `computeReachable`) rather than trusting a caller-supplied cost/target. The UI's
   cached "reachable/attackable" sets are a rendering hint only. Bake this in now so a
   future network layer doesn't require re-auditing every action.
4. **All randomness flows through a seeded RNG.** Make `rando.js` seedable
   (`Rando.seed(n)`, e.g. mulberry32) and route map gen, spawns, and AI through it. Store
   the seed in `GameState`; the engine re-seeds at the start of each new game. Result: the
   whole game reproduces from `state.seed` alone. The **only** raw `Math.random()` left is
   the one-time draw that *picks* a seed when none is supplied.
5. **Rules vs. display is a hard line.** The engine reads `GameArtifacts`, never
   `GameDisplayArtifacts`. Verify by running the headless core with the display file not
   even loaded (see Verify).

## Where a new feature goes

A game feature is **not one module** — it's a cross-cutting concern whose facets split
across the same layers. Decomposing it the same way is the whole discipline; putting a
feature in "one module" re-conflates data and behavior. Example — a skill or a weapon
affix:

| Facet | Module |
|---|---|
| Static catalog (what exists, cost/range/effect descriptor) | `GameArtifacts` |
| Icon, tint, display name, flavor text | `GameDisplayArtifacts` |
| Per-game instance (owned skills, cooldowns, rolled affixes, charges) | `GameState` |
| Resolution (spend cost, compute effective stats, apply effect, tick cooldowns) | `GameEngine` |
| Activation (hotbar, targeting modal, highlight legal targets) | `GameUI` |

Keep resolution **data-driven** — dispatch on a declared hook/op (`{stat, op, value}` for
passives, `{hook:'onHit', effect}` for procs), never `if (affix === 'keen')`. Only once
effects become real code (not plain data) is a separate engine-side effect **registry**
(`effects.js`, `Map<id, (state, ctx) => …>`) warranted.

Leave **inert extension points** for optional layers you aren't building yet:
`computeAttackable()` returns an empty set (no combat), a `targeting` modal state (no aimed
abilities), `locationAt()` returns null (no interactive locations). The dispatch already
routes to them; fill them in when the feature lands.

## Globals & load order (double-click friendly)

These prototypes must run from `file://` on a double-click, so use **plain `<script>`
globals, not ES modules**. Two rules:

- Wrap each module in an IIFE returning its single global, so destructured helper names
  (`const { TERRAIN } = GameArtifacts`) stay local and can't collide across files — two
  classic scripts each doing top-level `const TERRAIN` is a `SyntaxError`.
- List scripts in `index.html` in dependency order:
  `artifacts → displayartifacts → libs (rando, colortheory, hex) → gamestate → gameengine → gameui → index`.

Drop every `import`/`export`; convert `export class X` / `export function f` to bare
`class X` / `function f` (top-level `class`/`const` in a classic script are shared across
all scripts by name). Delete the old `config.js` once its contents move into the two
artifacts files.

## Verify (no test framework — these prototypes have none)

Verify headless with Node by concatenating the DOM-free files and exercising the engine —
do **not** add a test framework or `.test.js` files.

1. **Core runs without display, proving the rules/display line:**
   ```bash
   cat artifacts.js rando.js colortheory.js hex.js gamestate.js gameengine.js > core.js
   # append asserts: typeof GameDisplayArtifacts === 'undefined';
   # newGame(seed) twice with same seed → identical player/target/enemies (reproducible);
   # different seed diverges; a legal move drops MP; an illegal move returns {ok:false};
   # run ~20 endTurns and assert AI units stay on passable hexes.
   node core.js
   ```
2. **UI boots under stubs** — stub `document.getElementById` (return an object with
   `textContent`, `classList.toggle`, `addEventListener`, `getContext`→no-op ctx `Proxy`)
   and `window`; concat all files incl. display + `gameui.js` + `index.js`; assert boot,
   a `selectPlayer()` producing a non-empty reachable set, and a `commitMove` dropping MP.
3. `node --check` every file.

Then browser-playtest — canvas behavior can't be fully checked headless.

## Deferred (the first things to add on an actual server port)

- **Command/intent layer.** Today `GameUI` calls engine methods directly — that direct
  call is the seam a network cuts. The real port replaces it with serializable intents
  (`{type:'move', q, r}`) that a server validates-then-applies. Structure the engine's
  return-outcome API now so this drops in cleanly.
- **`GameState` (de)serialization** — `toJSON`/`fromJSON` (or diffs) to ship state/events
  over the wire.

## Update the project's CLAUDE.md

Reflect the new file layout: the module table, the plain-script-globals + load-order note,
the seeded-RNG/reproducibility note, and the "engine never reads display" line. These
prototypes forbid tests — keep that convention.
