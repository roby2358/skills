---
name: game-productize
description: >-
  Audit a browser game for ship-readiness and produce a tiered gap list: a SHIP.md in the
  game repo plus pjpd tasks. Covers the things that get forgotten between "the game works"
  and "a stranger can play it": title/menus/end screens, save and resume, audio and
  settings, onboarding, localization readiness, the mobile "sorry" screen for desktop-only games, error recovery,
  hosting on your own site and on portals (itch.io, Newgrounds), credits, asset provenance,
  and AI disclosure. Use when the user says "productize", "/game-productize", "get this
  game ready to ship/release/publish", "what's missing before I launch", "prep for
  itch.io", or asks for a release checklist or ship audit of a game. Advisory: it reports
  gaps and does not fix them unless asked.
---

# Productizing a game

The game is fun and it works on the author's machine. This skill finds what is missing
before a stranger can find it, learn it, finish it, and come back. It is an **audit**: it
inspects, reports, and files tasks. It does not implement fixes unless the user asks
afterward.

Defaults assumed unless the game says otherwise: free, no monetization, desktop
(mouse and keyboard) only, shipped on the author's own site and on web portals, made
largely with AI and proud of it.

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

Run the game (see the `run` skill) and play the first few minutes as a stranger would.
Most onboarding and menu gaps are visible only in play, not in code.

### 2. Ask only what the repo cannot answer

Ask these in one batch, and skip any the repo or an existing SHIP.md already answers:

- **Targets** for this game: own site, itch.io, Newgrounds, other.
- **Telemetry**: none, error reporting only, or cookieless counts plus a few game events.
  Present the tradeoff each time; there is no standing default.
- **Languages**: English only, or which others. Readiness is audited either way;
  translation only if languages are chosen.
- **Ship tier** the user is aiming for, if they already know (see Tiers). If they do not,
  report against all three and let them pick the cut line from the report.

### 3. Audit against the checklist

Read [references/checklist.md](references/checklist.md) and walk every area. For each
item record a status and evidence:

| Status | Meaning |
|---|---|
| `done` | Present and working. Cite `file:line` or what you saw in play. |
| `partial` | Exists but has a named hole. Say what the hole is. |
| `missing` | Not there. |
| `n/a` | Does not apply to this game. Say why in a few words. |
| `unverified` | Could not check (needs a device, a portal upload, a human ear). Say what would verify it. |

Never mark `done` from the code alone when the item is about player experience; play it.
If any target is a portal, also read [references/portals.md](references/portals.md).

The checklist is a floor, not a ceiling. Add game-specific items when play turns up a
gap the checklist does not name, and say they are additions.

### 4. Write SHIP.md

Write `SHIP.md` at the game repo root using the format below. If one exists, update it in
place: keep the user's decisions and cut line, re-check every item, and move fixed items
to `done`. Do not carry forward a status without re-verifying it.

### 5. File pjpd tasks

After SHIP.md is written, file one pjpd task per `missing` or `partial` item at or above
the cut line (all tiers if no cut line is set yet).

- List existing todo tasks first and update a matching one rather than filing a duplicate.
- `description`: self-contained. First line is the gap in plain words; then where it
  shows up, what done looks like, and the SHIP.md item id.
- `tag`: names the gap (`mobile-sorry`, `save-version`, `credits`), never the game.
- `priority`: Tier 1 gaps 80 to 90, Tier 2 50 to 65, Tier 3 20 to 35. Within a tier,
  rank by how many first-time players the gap loses.
- Record each task id next to its item in SHIP.md.

If pjpd tools are unavailable, say so and leave the task column empty; SHIP.md alone is
still a complete result.

### 6. Report

Tell the user, in this order: whether the game is shippable at each tier, the Tier 1
gaps by name, anything `unverified` that needs them, and the decisions still open.
Do not start fixing.

## Tiers

Every checklist item carries a tier. The tier is the lowest bar at which its absence
blocks shipping.

| Tier | Name | The bar |
|---|---|---|
| **T1** | Jam-plus | It loads, it can be won or ended, it does not lose progress, nothing in it is unlicensed, and a phone visitor is told the truth. |
| **T2** | Solid hobby release | A stranger can find it, learn it, finish it, and come back without hitting a wall or needing the author. |
| **T3** | Commercial-grade | What a paid indie game would have even though this one is free: full accessibility pass, remapping, shipped translations, measured performance. |

A game ships at tier N when every item at tier N and below is `done` or `n/a`.
An item's tier can move for a specific game; a multi-hour game makes save versioning T1,
a 90-second arcade game makes it `n/a`. Say so when you move one.

## SHIP.md format

```markdown
# SHIP: <Game name>

Audited <YYYY-MM-DD> at <commit short hash>.

## Verdict

| Tier | Ready? | Open items |
|---|---|---|
| T1 Jam-plus | no | 3 |
| T2 Solid hobby | no | 9 |
| T3 Commercial-grade | no | 17 |

**Cut line:** <tier the user chose, or "not chosen yet">

## Decisions

- Targets: own site, itch.io
- Devices: desktop only; mobile gets the sorry screen
- Telemetry: none
- Languages: English only; string table ready for more
- AI disclosure: <the drafted statement>

## Blocking the cut line

Ordered by how many first-time players each one loses.

| Id | Item | Status | Evidence | Task |
|---|---|---|---|---|
| MOB-1 | Mobile sorry screen | missing | index.html has no viewport or pointer check | mobile-sorry-0412 |

## By area

One table per checklist area, every item, same columns plus Tier.

## Provenance

| Asset | Kind | Source | License / terms | In credits? |
|---|---|---|---|---|

## Unverified

What could not be checked and what would check it.
```

Item ids come from the checklist (`MENU-2`, `SAVE-1`) and stay stable across re-audits so
tasks and SHIP.md keep pointing at each other. Game-specific additions use `X-n`.

## Principles

- **Audit as a stranger.** The author knows the rules, the controls, and where to click.
  Every gap this skill exists to find is invisible to the author for that reason.
- **Evidence or it is not done.** A status without a citation or an observed behavior is a guess.
- **Truth over polish.** A plain screen that says "this game needs a mouse and keyboard"
  beats a broken layout on a phone. A missing feature that is disclosed beats one that is faked.
- **AI-made, stated plainly and with enthusiasm.** Disclosure is a feature of the
  credits, not a confession. Say which tools made what, with no hedging and no apology.
  Still inventory everything: tool terms and third-party fonts and libraries have
  licenses whether or not a model wrote the code.
- **Do not grow the game.** Productizing closes gaps around the game. A finding that
  amounts to a new mechanic belongs in the game-design conversation, not in SHIP.md.
