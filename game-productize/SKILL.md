---
name: game-productize
description: >-
  Audit a browser game for ship-readiness and produce a tiered gap list: a SHIP.md in the
  game repo plus pjpd tasks. Finds what gets forgotten between "the game works" and "a
  stranger can play it": title/menus/end screens, save and resume, audio and settings,
  onboarding, the mobile "sorry" screen, localization readiness, error recovery, hosting
  on the author's site and on portals (itch.io, Newgrounds), credits, asset licenses, and
  AI disclosure. Use when the user says "productize", "/game-productize", "get this game
  ready to ship/release/publish/launch", "what's missing before I launch", "prep for
  itch.io/Newgrounds", or asks for a release checklist or ship audit of a game. Advisory:
  it reports gaps and does not fix them.
---

# Productizing a game

The game is fun and it works on the author's machine. Find what is missing before a
stranger can find it, learn it, finish it, and come back. This is an **audit**: inspect,
report, file tasks. Do not implement fixes unless the user asks afterward.

Defaults, unless the game says otherwise: free, no monetization, desktop only (mouse and
keyboard) with a "sorry" screen for phones, shipped on the author's own site and on web
portals, made largely with AI and proud of it.

## Workflow

### 1. Detect what the game is

Read the repo before asking anything. Establish:

- **Shape**: single-file prototype, factored (`GameEngine` / `GameState` / `GameUI`), or
  client plus server. Build step or plain script tags.
- **Persistence**: any `localStorage` / IndexedDB / server save, and what is stored.
- **Audio**: present or absent.
- **Session length**: one sitting or many. This decides how much save and resume matters.
- **Network**: any outbound request, third-party script, font CDN, or analytics.
- **Docs**: SPEC.md, ONTOLOGY.md, DYNAMICS.md, an existing SHIP.md, a LICENSE, credits.

Then run the game (see the `run` skill) with storage cleared and play the first few
minutes as a stranger would, console and network tab open. Most menu and onboarding gaps
show only in play. If the game cannot be run in this session, say so up front; every
item that needs play is then `unverified`, not `done`.

### 2. Ask only what the repo cannot answer

Ask in one batch, skipping anything the repo or an existing SHIP.md already answers:

- **Targets**: own site, itch.io, Newgrounds, other.
- **Telemetry**: present this tradeoff every time; there is no standing default.

  | Option | You learn | You owe |
  |---|---|---|
  | None | Nothing unless players write in | Only to verify there is truly nothing |
  | Error reporting only | Crashes in the wild, with stack and version | A one-line notice; no personal data, no IPs stored |
  | Cookieless counts plus a few game events | Visits, and where players stop | A short privacy note; events anonymous and few |

- **Languages**: English only, or which others. Readiness is audited either way;
  translation items only for languages chosen.
- **Cut line**: the tier the user is aiming for (see Tiers), if they already know.
  Otherwise report all three and let them pick from the report.

### 3. Audit against the checklist

Read [references/checklist.md](references/checklist.md) and walk every area. If any
target is a portal, also read [references/portals.md](references/portals.md). Give each
item a status and evidence:

| Status | Meaning |
|---|---|
| `done` | Present and working. Cite `file:line` or what was seen in play. |
| `partial` | Exists but has a named hole. Say what the hole is. |
| `missing` | Not there. |
| `n/a` | Does not apply to this game. Say why in a few words. |
| `unverified` | Could not check (needs a device, a portal upload, a human ear). Say what would verify it. |

Never mark a player-experience item `done` from code alone; play it. The checklist is a
floor: when play turns up a gap it does not name, add it as an `X-n` item with a tier.

### 4. Write SHIP.md

Write `SHIP.md` at the game repo root in the format below. If one exists, update it in
place: keep the Decisions, cut line, task ids, and `X-n` items, and re-verify every
status rather than carrying it forward.

### 5. File pjpd tasks

File one task per `missing` or `partial` item in the tiers up to and including the cut
line. With no cut line chosen yet, file Tier 1 only (it blocks every cut line) and file
the rest once the user picks. Use `pjpd_list_tasks` and `pjpd_put_task`:

- **Dedupe first.** List `todo` and `done` tasks with a `count` high enough to see them
  all (the default is 20). If one already covers the gap, update it by `id` and omit
  `priority` so the user's own ranking survives. Never mark tasks done or verified;
  name in the report any open task whose item now reads `done`.
- `tag` (new tasks only): names the gap, never the game. 1 to 12 characters, letters,
  digits, and hyphens: `mobile-sorry`, `save-version`, `credits`. pjpd returns the id as
  `<tag>-XXXX`.
- `description`: self-contained. First line is the gap in plain words, under 100
  characters (it is the list summary). Then where it shows up, what done looks like, and
  the SHIP.md item id.
- `priority`: Tier 1 gaps 80 to 90, Tier 2 50 to 65, Tier 3 20 to 35. Within a tier,
  rank by how many first-time players the gap loses.
- Write each returned task id into the item's Task column in SHIP.md.

pjpd tasks are work for the AI to do. An `unverified` item that needs the user (a
friend's playtest, a listening pass, a browser they own) gets no task; it stays in the
report and in SHIP.md's Unverified section.

pjpd keeps its tasks in the repo it runs in (`pjpd/tasks.txt`), so run the audit from
the game's repo and the tasks land with the game. If the session is in a different repo,
say so and ask before filing. If pjpd tools are unavailable, say so and leave the Task column empty;
SHIP.md alone is a complete result.

### 6. Report

Tell the user, in this order: whether the game is ready at each tier, the Tier 1 gaps by
name, anything `unverified` that needs them, the decisions still open, and what was
filed. Do not start fixing.

## Tiers

Every checklist item carries a tier: the lowest bar at which its absence blocks shipping.

| Tier | Name | The bar |
|---|---|---|
| **T1** | Jam-plus | It loads, it can be won or ended, it does not lose progress, nothing in it is unlicensed, and a phone visitor is told the truth. |
| **T2** | Solid hobby release | A stranger can find it, learn it, finish it, and come back without hitting a wall or needing the author. |
| **T3** | Commercial-grade | What a paid indie game would have even though this one is free: full accessibility pass, remapping, shipped translations, measured performance. |

A game is ready at tier N when every item at tier N and below is `done` or `n/a`;
`partial`, `missing`, and `unverified` are all open.

Tiers are defaults. Move an item when the game's shape calls for it (a multi-hour game
makes save versioning T1) and note the move in the item's Evidence.

## SHIP.md format

```markdown
# SHIP: <Game name>

Audited <YYYY-MM-DD> at <commit short hash>.

## Verdict

| Tier | Ready? | Open items (this tier and below) |
|---|---|---|
| T1 Jam-plus | no | 3 |
| T2 Solid hobby | no | 12 |
| T3 Commercial-grade | no | 29 |

**Cut line:** <tier the user chose, or "not chosen yet">

## Decisions

- Devices: desktop only; mobile gets the sorry screen
- Telemetry: none
- Languages: English only; string table ready for more
- AI disclosure: <the drafted statement>

Write `open` for any the user has not made.

## Targets

| Target | URL | Frame size | Commit live | Date | How to deploy |
|---|---|---|---|---|---|
| Own site | | n/a | | | |
| itch.io | | 960x540 | | | |

## Blocking the cut line

Open items up to the cut line (Tier 1 if not chosen yet), ordered by how many first-time
players each one loses.

| Id | Item | Tier | Status | Evidence | Task |
|---|---|---|---|---|---|
| MOB-1 | Mobile sorry screen | T1 | missing | index.html has no pointer or viewport check | mobile-sorry-0412 |

## By area

One table per checklist area (and PORT when a portal is targeted), every item, same
columns.

## Provenance

| Asset | Kind | Source | License / terms | In credits? |
|---|---|---|---|---|

## Unverified

What could not be checked and what would check it.
```

Item ids come from the checklist (`MENU-2`, `SAVE-1`, `PORT-3`) and stay the same across
re-audits so tasks and SHIP.md keep pointing at each other.

## Principles

- **Audit as a stranger.** The author knows the rules, the controls, and where to click,
  which is why these gaps are invisible to the author.
- **Truth over polish.** A plain screen that says "this game needs a mouse and keyboard"
  beats a broken layout on a phone. A missing feature that is disclosed beats one that is faked.
- **AI-made, stated plainly and with enthusiasm.** Disclosure is a feature of the
  credits, not a confession. Say which tools made what, with no hedging and no apology.
  Still inventory everything: tool terms and third-party fonts and libraries have
  licenses whether or not a model wrote the code.
- **Do not grow the game.** Productizing closes gaps around the game. A finding that
  amounts to a new mechanic belongs in the game-design conversation, not in SHIP.md.
