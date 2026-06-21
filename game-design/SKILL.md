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
5. **Gut check every mechanic.** Does it satisfy common sense? If a player encounters it cold, will it feel intuitive or backwards? A mechanic that requires explanation is fighting the player's instincts. Fire should hurt, armor should protect, retreating to safety should heal. When a mechanic *must* defy intuition (e.g., closing a spawn point makes remaining enemies stronger), the player needs to feel the logic immediately — otherwise it reads as a bug, not a design.
6. **Name the driver** for every mechanic. If you can't, cut it.

DYNAMICS.md is a living document. Update it when mechanics change. It is the authoritative reference for *why* the game works, not just *what* the game does.

7. **Code-check every mechanic.** Every mechanic must be expressible as a clear algorithm — a turn loop step, a conditional check, a state mutation. If you can't describe it as pseudocode in 5 lines, it's too vague to implement. "Unique encounter" is not a mechanic. "If your unit is on the objective hex AND an ally is within 3 hexes, spend 2 MP to claim" is. Prefer one code path that handles all cases over special-case branches per content item.
8. **Template, don't snowflake.** When designing content that varies (items, abilities, units), define a small set of mechanical templates first (passive modifier, activated-self, activated-targeted, one-use). Each content item is a parameter set for a template, not a unique code path. 20 items should require ~4 templates and ~16 effect functions, not 20 bespoke implementations.
9. **Write a Strategies section.** After mechanics are defined, enumerate the play patterns the design should support: early/mid/late game approaches, recurring tensions (trade-offs that come up every game), and anti-strategies (degenerate patterns the design must prevent). Review every strategy against the actual mechanics — if a strategy references a rule that doesn't exist, or if a mechanic has no strategy that uses it, something is wrong. This review frequently surfaces:
   - Inconsistencies (a strategy assumes a rule that was never formalized)
   - Missing rules (anti-strategy has no mechanical prevention)
   - Dead mechanics (a feature no strategy ever engages with)
   - Unfair asymmetries (an NPC that trivially dominates because its constraints weren't tested against player capabilities)
10. **Source material is mechanics fuel, not mechanics.** When adapting fiction (stories, lore, IP), extract the *relationships and tensions* — not the plot beats. A character who "tricks the hero" becomes an NPC with an information asymmetry mechanic. A creature "too powerful to fight" becomes a puzzle with a non-combat solution. Map story dynamics to game dynamics; don't literalize scenes into special-case encounters.

---

## Survival and Thriving

These are the verbs of play — what the player actually does moment to moment. Pick the few your theme naturally activates and let the game express what each means. Activities don't need to be named to be felt.

These dynamics must consider cost of materials, process costs, risks, and rewards. Each activity's payoff must depend on game state — clearly worth it in some situations, clearly not in others. The decision the player makes is whether and when. These activities are expressions of Variable Reinforcement, Low-Probability Hope, and Double-Edged Mechanics.

A game may pull one of these threads to the front — its dominant mechanic, the one the player is really playing. Promote *defense* and you have tower defense; promote *diplomacy* and the combat, trading, and reputation below it become the leverage you bring to the table. Or it may weave the activities into a tapestry.

- gathering
- crafting
- hunting
- healing
- creativity and expression
- exploration
- storytelling and ritual
- territory
- combat
- defense
- diplomacy
- building
- repair
- trading
- farming
- mining
- reputation
- prestige
- influence
- command

---

## Why Is This Fun?

Every mechanic must serve at least one of these psychological drivers. If a proposed feature doesn't strengthen any of them, it doesn't belong. When evaluating a design decision, name which driver it serves.

### Scarcity of Agency

Fun comes from never having enough. Few units, limited moves, spreading doom — every turn is triage. The player can't address all threats, so choosing *which problem to ignore* is the core decision. Constraint makes each action feel weighty. More units, more moves, more time all dilute this.

### Readable Consequences

The player must have enough information to form a plan and, critically, to see where their plan broke down. This is the "one more game" hook: not randomness, but the belief that a better sequence of decisions exists. If the player can't trace cause to effect, failure feels arbitrary and they quit.

### Near-Miss Architecture

Tune so the player *almost* succeeds. The escalation curve should guarantee that early game feels manageable and the final stretch punishes. Replay comes from seeing exactly where it went wrong — "if I'd reached that objective one turn earlier." A game that's unwinnable doesn't generate near-misses. A game that's easy doesn't either.

### Variable Reinforcement on a Competence Backbone

Enough variance (random spawns, map layout, spread patterns) that each run feels different. But unlike a slot machine, the player is making real decisions with that variance. The ratio isn't 50% payout — it's "I earned this outcome but luck shaped the edges." If decisions don't matter, it's gambling. If luck doesn't matter, it's optimization homework.

### Guardianship

The player must care about what they're protecting. Named units with distinct abilities, a home base worth defending, allies whose positioning keeps each other alive — these create personal stakes. Abstract loss ("your score decreases") doesn't motivate. Specific loss ("the healer dies and now nobody heals") does. Every unit and landmark should be something the player would mourn losing.

### Loss Aversion Over Reward-Seeking

Protecting something you have is more motivating than chasing something you don't. Heal mechanics, safe zones, and unit preservation tap into this. The player isn't collecting loot — they're preventing death. Every unit lost is a permanent reduction in agency (see driver #1), which makes losses sting and survival feel earned. Guardianship is what makes loss aversion personal rather than abstract. Note: this coexists with Accumulation — the player *is* building toward something, but what they're accumulating is positional advantage and tactical knowledge, not power. The frame is still protection; the progress is strategic, not material.

### Revenge as Fuel

When the player loses something they were guarding, the game should channel grief into aggression. Revenge directly activates the reward system — hunting down the enemy that killed your unit feels *good* in a way that abstract objective-completion doesn't. Design so that losses create a target: the player should know *who* did it and be able to reach them. Revenge converts a negative experience (loss) into forward momentum (pursuit), which prevents loss from becoming despair.

### Escalating Commitment

The game must force the player forward into worse odds. No turtling. Each objective completed should make the remaining ones harder, creating a crescendo toward a desperate final push. The emotional payoff is surviving (or nearly surviving) that crescendo.

### Accumulation and Windfall

Within a game of managed decline, the player needs to feel themselves *building* toward something — not just holding the line. Small gains that compound: map knowledge accumulating, positioning improving turn by turn, a unit inching closer to an objective. Incremental progress is what separates strategy from survival horror. Then, when those small investments converge — a chain reaction, a positional setup that suddenly pays off, three turns of careful maneuvering collapsing into one devastating move — the windfall feels *earned*, not lucky. The baseline is loss management, but the ceiling should be exponential. Design systems where patient accumulation can tip into explosive gain. These moments are rare by design — if windfalls are common, they stop feeling like windfalls and the game loses its scarcity of agency.

### Comedy

Sometimes a choice is justified simply because it's funny. Confusion resolved into *unexpected* harmony — an ability interaction nobody planned for, an enemy walking into its own doom, a desperate move that works for the wrong reasons — these moments create the stories players retell. Comedy is the release valve for tension. Design should leave cracks where absurdity can emerge: overlapping systems that occasionally produce ridiculous outcomes are a feature, not a bug.

---

## Mechanical Principles

Tools for building systems that serve the drivers above.

### Asymmetry Over Symmetry

Give factions different relationships with shared systems. One mechanic with two meanings creates more tension than separate mechanics per faction. *Serves: scarcity of agency (player has fewer safe options), loss aversion (asymmetric hazards threaten what you have).*

*Example: Hazard terrain damages player units but shelters enemies.*

### Roles Through Mechanical Exceptions

Define unit identity by what rules they break, not stat deltas. A unique interaction with a core system creates trade-offs that force decisions. Overlapping exceptions are also where comedy emerges — when two rule-breaking abilities interact in ways nobody anticipated. *Serves: scarcity of agency (each unit can't do everything), readable consequences (abilities have clear tactical implications), guardianship (distinct abilities make each unit irreplaceable), comedy (exception collisions produce surprises).*

*Example: A ranged unit that doesn't advance onto a killed enemy's hex — safe damage, but can't seal objectives by combat alone.*

*Example: A support aura rewards clustering; bonus speed rewards splitting. Roles create mechanical tension.*

### Simplify Until It Hurts

If a mechanic only has one effect that matters in play, collapse it to that effect. Fewer concepts at the same depth keeps the player's mental model clean and consequences readable. *Serves: readable consequences (less noise between decision and outcome).*

*Example: "Resources" that only grant healing are just healing terrain — delete the abstraction.*

### Escalation Tied to Progress

Difficulty scales with player success, not time. The player's own victories trigger the crescendo. *Serves: escalating commitment, near-miss architecture.*

*Example: Spawn rate scales with open spawn points remaining — closing them makes the survivors deadlier.*

### Low-Probability Hope

Rare positive events sustain morale during attrition without trivializing difficulty. The *possibility* matters as much as the outcome. *Serves: variable reinforcement, loss aversion (a reason to hold on one more turn), accumulation (a new ally compounds existing positioning).*

*Example: 10% chance per turn to spawn an ally — unlikely on any given turn, probable over 15.*

### Terrain as Language

Terrain should communicate strategy at a glance. When terrain carries gameplay meaning (cost, healing, spread resistance), map generation becomes level design. *Serves: readable consequences (the player sees the plan in the map).*

*Example: Water blocks the spreading hazard — rivers become defensive lines without explicit walls.*

### Landmarks as Anchors

A location that's mechanically important (not just central) creates a push-out vs. fall-back trade-off. *Serves: scarcity of agency (can't be everywhere), escalating commitment (eventually must leave safety), guardianship (a place worth protecting).*

*Example: A tower providing aura heal + reinforcement spawns — worth defending but the objectives are elsewhere.*

### Enemy Identity

Enemies should be distinguishable and trackable — not interchangeable threat units. When a specific enemy kills the player's unit, the player should be able to identify it and hunt it. Anonymous swarms dilute revenge; named threats focus it. *Serves: revenge (a target for grief), readable consequences (threat assessment), guardianship (knowing which enemy threatens which unit).*

*Example: The enemy that killed your melee unit is still on the board, one hex away from your healer.*

### Compounding Systems

Design mechanics that layer on each other over time. Position, map knowledge, unit synergies, and cleared territory should all accumulate as the player invests turns. When multiple small advantages converge in a single move, the payoff should feel disproportionate to any single input. *Serves: accumulation and windfall (incremental gains tip into explosive moments), readable consequences (the player traces the payoff back to earlier decisions).*

*Example: Healing terrain + support aura + rest bonus stacking on one unit; clearing a corridor that enables a two-turn objective rush.*

### Information as Currency

Knowledge of the game state is itself a resource to design around. Hidden information (fog, unrevealed locations) creates exploration. Shared information (revealing something to a rival) creates races. Asymmetric information (one side knows what the other doesn't) creates tension. Design information mechanics with the same care as movement or combat — who knows what, when do they learn it, and what does it cost? *Serves: scarcity of agency (scouting costs actions), accumulation (map knowledge compounds), readable consequences (the player chose what to reveal).*

*Example: One scouting method reveals objective locations but also alerts a rival NPC. Another reveals them privately but requires interpretation. Two paths to the same goal with different information costs.*

### Rival NPCs Need Constraints

An NPC competitor (rival, thief, opposing force) must operate under rules the player can understand, predict, and counter. If a rival can go anywhere at any speed with perfect knowledge, it's not a challenge — it's a timer with legs. Give rivals: (a) information limits (they only know what's been revealed), (b) terrain costs (same movement rules as players), (c) commitment patterns (they lock onto a target and don't omnisciently switch), (d) at least one counterplay the player can execute at a real cost. Test the rival by asking: "Can the player ever outmaneuver this NPC, or just outrace it?" If the answer is only outrace, the rival needs more constraints. *Serves: readable consequences (player can predict rival behavior), scarcity of agency (counterplay costs something).*

### State Must Fit in a Struct

Every piece of game state must be a named field in a data structure. If a mechanic requires tracking something that doesn't have a home in the state model, either the mechanic is too vague or the state model is incomplete. Write the state model early — it exposes hidden complexity. A mechanic that needs 5 new fields is more expensive than one that reuses existing fields. *Serves: readable consequences (if you can't model it, you can't display it).*

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

### Strategy Review Catches Bugs

After writing the Strategies section, read each strategy as if you're an adversarial player trying to break the game. For every anti-strategy ("this shouldn't work"), verify the *specific mechanic* that prevents it. If the prevention is "it would be boring" or "it's suboptimal," that's not enough — degenerate strategies get used if they work, regardless of fun. Common bugs this catches:
- NPC rivals with no information limits (omniscient = unfair)
- NPC rivals with no terrain constraints (teleporting = unfair)
- Anti-turtle pressure that doesn't exist mechanically (just saying "enemies escalate" isn't enough if the escalation is too slow)
- Strategies that reference rules you forgot to formalize
- Win conditions that conflict with the strategies needed to reach them (e.g., "both units must escape" but one strategy sends them in opposite directions)

### Double-Edged Mechanics Are Gold

The best mechanics serve two purposes that pull in opposite directions. Revealing a treasure *also* alerts your rival. Claiming an objective *also* increases enemy spawns. Splitting your units covers more ground *but* makes one vulnerable. When a single action has both upside and downside, the player faces a genuine decision every time. If a mechanic only has upside, it's not a decision — it's a chore. If it only has downside, it's not a decision — it's punishment.

### Bake Costs Into Systems, Don't Bolt Them On

When an action has a cost, embed it in the system that governs the action — don't add a separate check. "Claiming costs 2 MP" becomes "+2 to the BFS movement cost of objective hexes." The hex simply doesn't highlight if you can't afford it. No modal, no notification, no special case. The player learns the cost by seeing the reachable hexes. This principle scales: if entering a hex has a side effect, make it part of the movement calculation, not a post-move handler. Fewer code paths, fewer surprises, fewer bugs.

### Shared Obstacles Create Emergent Alliances

When a threat affects multiple actors (player units AND rival NPCs), the game board generates its own stories. Enemies that target both the player and the rival turn the swarm from a pure hazard into a tactical tool — the player's problem becomes the rival's roadblock. Design threats that don't discriminate. This is where comedy emerges: an enemy spawn that accidentally blocks the rival from an objective she was about to claim, or an enemy chasing the rival into a dead end she has to detour around. *Serves: comedy, variable reinforcement, readable consequences.*

### NPC Rivals Need the Same Return Trip

If the player must go out and come back (collect objectives, return to base), the rival must too. A rival that only needs to *reach* an objective is just a timer — the player can never intercept or counterplay on the return. When both sides must make the round trip, the player can: (a) race to collect first, (b) block the return path, (c) use terrain and obstacles strategically. The return trip is where rival-blocking and enemy-as-barrier tactics become viable. Without it, the rival is a clock you watch helplessly.

### Pathfinding Needs Global Vision

When an NPC uses pathfinding, use full A* to the target and walk the path within the MP budget. Do NOT use local BFS (limited by MP radius) to pick the "best reachable hex" — this creates a horizon problem where the NPC can't plan detours longer than one turn's movement. The NPC gets stuck on coastlines, behind obstacles, in dead ends. Full pathfinding, then walk. Always.

### Ecology Over Choreography

Design enemy behavior as a simple ecology (spawn, move, decay, hesitate) rather than scripted encounters. A few probabilistic rules — 20% spawn chance, 20% decay when distant, 50% hesitation near a strong unit — create emergent board states that feel alive and different every game. The player reads the "weather" of the board rather than solving a predetermined puzzle. Tune the rates through play: halve and double first, then find the feel. *Serves: variable reinforcement, near-miss architecture.*

### Variable Speed Creates Dread

Instead of uniform enemy movement, roll speed per enemy at spawn (e.g., 1d6: 1-3 = slow, 4-5 = fast, 6 = very fast). A swarm where any individual enemy might be the fast one makes every spawn feel threatening, even when most are slow. The player can't rely on counting hexes to feel safe — a speed-3 enemy closing from 4 hexes away is a surprise death. This is cheap to implement (one field per enemy, loop the greedy-move step N times) and dramatically changes the feel of the threat. *Serves: variable reinforcement, near-miss architecture, readable consequences (the player sees the fast one coming and must react).*

### Death Should Be an Event, Not a State Check

Don't check "is the player in a bad position at end of turn" — let the bad thing actually *happen* on screen. An enemy that moves onto the player's hex and kills them is dramatic. A post-turn check that says "you were adjacent to an enemy and too far from safety" is a rule violation notice. When death is an active event in the enemy movement phase, the player sees it coming, watches it unfold, and knows exactly which enemy and which decision killed them. This also opens design space for protection mechanics: the guardian unit's proximity makes the hex *impassable* to enemies, which is a spatial mechanic the player can reason about visually. *Serves: readable consequences (cause and effect are visible), revenge (the player saw who did it), near-miss architecture (the enemy was one hex away — next time, stay closer).*

### Animate the Enemy Phase

The enemy phase is where consequences land — don't skip it. A combat flash when the guardian kills enemies, hop-by-hop movement so the player can track each enemy's advance, a death bang when something goes wrong. These animations serve three purposes: (1) they give the player time to *read* what happened, (2) they make enemy actions feel like real events rather than instant state changes, and (3) they create tension as fast enemies close distance in visible steps. Implementation: split the turn resolution into phases connected by animation callbacks (combat flash → enemy movement hops → post-movement checks). Each phase renders, animates, then calls the next. Keep animations short (200ms per hop, 20 frames for a flash) — the goal is readability, not spectacle.

### Home Bases Give the Map Emotional Weight

A named location the player starts from and must return to transforms the map from a search space into a journey. "Go into the wilds, find treasure, come home" is a story. "Collect 3 things and step on an edge hex" is a rule. The mechanical difference is trivial (check city hex vs. check edge hex), but the emotional difference is enormous. Cities, towers, camps — any landmark that says "you belong here" makes the departure feel brave and the return feel earned. *Serves: guardianship, landmarks as anchors.*
