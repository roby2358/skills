---
name: game-design
description: >
  Design principles for tactics and strategy games. Use when designing new
  mechanics, tuning existing systems, adding units or abilities, adjusting
  difficulty, or making any game design decision. Triggers on discussions about
  game balance, unit roles, terrain, pacing, spawning, healing, combat,
  win/loss conditions, or UI for conveying game state.
---

# Game Design Principles

## Workflow

When designing a new game or a major new system, start by creating a **DYNAMICS.md** document. This is not a spec — it's a design journal that answers "Why is this fun?" before any mechanics are written.

### DYNAMICS.md Process

1. **Theme first.** What is the emotional experience? Not setting or plot — the *feeling*. "Desperate last stand against encroaching doom" is a theme. "Fantasy tactics on a hex grid" is not.
2. **Choose 2-3 key drivers** from the list below that the theme naturally activates. These are the load-bearing pillars. Every other mechanic weaves into them.
3. **Design key mechanics** — one per driver. Each mechanic should be a single sentence. If it takes a paragraph to explain, it's too complex or it's actually two mechanics.
4. **Weave secondary mechanics** into the key ones. Every new mechanic must connect to an existing one. If it stands alone, it's bloat. Ask: "What existing mechanic does this make more interesting?"
5. **Name the driver** for every mechanic. If you can't, cut it.

DYNAMICS.md is a living document. Update it when mechanics change. It is the authoritative reference for *why* the game works, not just *what* the game does.

---

## Why Is This Fun?

Every mechanic must serve at least one of these psychological drivers. If a proposed feature doesn't strengthen any of them, it doesn't belong. When evaluating a design decision, name which driver it serves.

### Scarcity of Agency

Fun comes from never having enough. Few units, limited moves, spreading doom — every turn is triage. The player can't address all threats, so choosing *which problem to ignore* is the core decision. Constraint makes each action feel weighty. More units, more moves, more time all dilute this.

### Readable Consequences

The player must have enough information to form a plan and, critically, to see where their plan broke down. This is the "one more game" hook: not randomness, but the belief that a better sequence of decisions exists. If the player can't trace cause to effect, failure feels arbitrary and they quit.

### Near-Miss Architecture

Tune so the player *almost* succeeds. The escalation curve should guarantee that early game feels manageable and the final stretch punishes. Replay comes from seeing exactly where it went wrong — "if I'd sealed that rift one turn earlier." A game that's unwinnable doesn't generate near-misses. A game that's easy doesn't either.

### Variable Reinforcement on a Competence Backbone

Enough variance (random spawns, map layout, spread patterns) that each run feels different. But unlike a slot machine, the player is making real decisions with that variance. The ratio isn't 50% payout — it's "I earned this outcome but luck shaped the edges." If decisions don't matter, it's gambling. If luck doesn't matter, it's optimization homework.

### Guardianship

The player must care about what they're protecting. Named units with distinct abilities, a home base worth defending, allies whose positioning keeps each other alive — these create personal stakes. Abstract loss ("your score decreases") doesn't motivate. Specific loss ("the Spore Marine dies and now nobody heals") does. Every unit and landmark should be something the player would mourn losing.

### Loss Aversion Over Reward-Seeking

Protecting something you have is more motivating than chasing something you don't. Heal mechanics, safe zones, and unit preservation tap into this. The player isn't collecting loot — they're preventing death. Every unit lost is a permanent reduction in agency (see driver #1), which makes losses sting and survival feel earned. Guardianship is what makes loss aversion personal rather than abstract. Note: this coexists with Accumulation — the player *is* building toward something, but what they're accumulating is positional advantage and tactical knowledge, not power. The frame is still protection; the progress is strategic, not material.

### Revenge as Fuel

When the player loses something they were guarding, the game should channel grief into aggression. Revenge directly activates the reward system — hunting down the enemy that killed your unit feels *good* in a way that abstract objective-completion doesn't. Design so that losses create a target: the player should know *who* did it and be able to reach them. Revenge converts a negative experience (loss) into forward momentum (pursuit), which prevents loss from becoming despair.

### Escalating Commitment

The game must force the player forward into worse odds. No turtling. Each objective completed should make the remaining ones harder, creating a crescendo toward a desperate final push. The emotional payoff is surviving (or nearly surviving) that crescendo.

### Accumulation and Windfall

Within a game of managed decline, the player needs to feel themselves *building* toward something — not just holding the line. Small gains that compound: map knowledge accumulating, positioning improving turn by turn, a unit inching closer to a rift. Incremental progress is what separates strategy from survival horror. Then, when those small investments converge — a chain reaction, a positional setup that suddenly pays off, three turns of careful maneuvering collapsing into one devastating move — the windfall feels *earned*, not lucky. The baseline is loss management, but the ceiling should be exponential. Design systems where patient accumulation can tip into explosive gain. These moments are rare by design — if windfalls are common, they stop feeling like windfalls and the game loses its scarcity of agency.

### Comedy

Sometimes a choice is justified simply because it's funny. Confusion resolved into *unexpected* harmony — an ability interaction nobody planned for, an enemy walking into its own doom, a desperate move that works for the wrong reasons — these moments create the stories players retell. Comedy is the release valve for tension. Design should leave cracks where absurdity can emerge: overlapping systems that occasionally produce ridiculous outcomes are a feature, not a bug.

---

## Mechanical Principles

Tools for building systems that serve the drivers above.

### Asymmetry Over Symmetry

Give factions different relationships with shared systems. One mechanic with two meanings creates more tension than separate mechanics per faction. *Serves: scarcity of agency (player has fewer safe options), loss aversion (asymmetric hazards threaten what you have).*

*Example: Void terrain damages player units but shelters enemies.*

### Roles Through Mechanical Exceptions

Define unit identity by what rules they break, not stat deltas. A unique interaction with a core system creates trade-offs that force decisions. Overlapping exceptions are also where comedy emerges — when two rule-breaking abilities interact in ways nobody anticipated. *Serves: scarcity of agency (each unit can't do everything), readable consequences (abilities have clear tactical implications), guardianship (distinct abilities make each unit irreplaceable), comedy (exception collisions produce surprises).*

*Example: A ranged unit that doesn't advance onto a killed enemy's hex — safe damage, but can't seal objectives by combat alone.*

*Example: A support aura rewards clustering; bonus speed rewards splitting. Roles create mechanical tension.*

### Simplify Until It Hurts

If a mechanic only has one effect that matters in play, collapse it to that effect. Fewer concepts at the same depth keeps the player's mental model clean and consequences readable. *Serves: readable consequences (less noise between decision and outcome).*

*Example: "Resources" that only grant healing are just healing terrain — delete the abstraction.*

### Escalation Tied to Progress

Difficulty scales with player success, not time. The player's own victories trigger the crescendo. *Serves: escalating commitment, near-miss architecture.*

*Example: Spawn rate scales with unsealed rifts remaining — sealing rifts makes the survivors deadlier.*

### Low-Probability Hope

Rare positive events sustain morale during attrition without trivializing difficulty. The *possibility* matters as much as the outcome. *Serves: variable reinforcement, loss aversion (a reason to hold on one more turn), accumulation (a new ally compounds existing positioning).*

*Example: 10% chance per turn to spawn an ally — unlikely on any given turn, probable over 15.*

### Terrain as Language

Terrain should communicate strategy at a glance. When terrain carries gameplay meaning (cost, healing, spread resistance), map generation becomes level design. *Serves: readable consequences (the player sees the plan in the map).*

*Example: Water blocks corruption spread — rivers become defensive lines without explicit walls.*

### Landmarks as Anchors

A location that's mechanically important (not just central) creates a push-out vs. fall-back trade-off. *Serves: scarcity of agency (can't be everywhere), escalating commitment (eventually must leave safety), guardianship (a place worth protecting).*

*Example: A tower providing aura heal + reinforcement spawns — worth defending but the objectives are elsewhere.*

### Enemy Identity

Enemies should be distinguishable and trackable — not interchangeable threat units. When a specific enemy kills the player's unit, the player should be able to identify it and hunt it. Anonymous swarms dilute revenge; named threats focus it. *Serves: revenge (a target for grief), readable consequences (threat assessment), guardianship (knowing which enemy threatens which unit).*

*Example: The Hollow Knight that killed your Hexblade is still on the board, one hex away from your Spore Marine.*

### Compounding Systems

Design mechanics that layer on each other over time. Position, map knowledge, unit synergies, and cleared territory should all accumulate as the player invests turns. When multiple small advantages converge in a single move, the payoff should feel disproportionate to any single input. *Serves: accumulation and windfall (incremental gains tip into explosive moments), readable consequences (the player traces the payoff back to earlier decisions).*

*Example: Healing terrain + support aura + rest bonus stacking on one unit; clearing a corridor that enables a two-turn rift rush.*

### Never Let a Unit Feel Stuck

Guarantee a minimum action even when costs would prevent it. If a rule blocks all options, the player loses agency — the one thing the game can't afford to take. *Serves: scarcity of agency (must preserve the feeling that scarce moves matter, not that you have zero moves).*

### UI Reveals Mechanics

Highlights, overlays, and panels are how players discover systems and trace consequences. Surface every meaningful mechanic at the moment of decision. *Serves: readable consequences.*

*Example: Yellow highlights for reachable hexes, red for attack targets — players learn by seeing, not reading.*

---

## Tuning Heuristics

### Halve and Double First

When a value feels wrong, adjust by 2x. Large swings test whether the *concept* works before fine-tuning numbers.

### Name the Driver

Before adding a mechanic, state which psychological driver it serves. The drivers are: scarcity of agency, readable consequences, near-miss architecture, variable reinforcement, guardianship, loss aversion, revenge, escalating commitment, accumulation and windfall, comedy. If you can't name one, reconsider.
