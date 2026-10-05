---
name: ontology_spec
description: Write and maintain an ontology-based design-doc set (ONTOLOGY.md + CRITERIA.md + RATIONALE.md, plus DYNAMICS.md for games) instead of a single SPEC.md. ONTOLOGY is the implementation reference — purpose, entities as structs, invariants, rules as short pseudocode, commands and events, numbers — with provenance tags ([D]/[P]/[T]) and Serves tags; CRITERIA turns every rule into input → expect tables with a named instrument; RATIONALE records decisions with alternatives and evidence. Use when starting a new app, game, or major system, when the user says "ontology", "/ontology_spec", or asks for design docs where the *why* and tuning history matter. Also use for a teleology review (does each thing still do what it's for?).
---

# Ontology Spec

A design-doc set that separates **what exists and how it behaves** (ONTOLOGY), **how we
know it's right** (CRITERIA), and **why each choice was made** (RATIONALE). For games and
other systems with emergent behavior, add **why it's fun / why it works** (DYNAMICS).

The gains come from three properties, not from the number of files:
1. **Tagged provenance** — the designer's decisions are never confused with Claude's guesses.
2. **Rationale with alternatives** — writing down what else was considered finds bugs.
3. **Criteria as tables** — rules arrive with their test cases, so tests are transcription.

If a project is a small CRUD feature, use the `specification` skill (SPEC.md) instead, and
borrow these three properties as sections. Use this format when the *why* matters as much
as the *what*: games, simulations, rule engines, protocols, anything that will be tuned.

After the docs exist, build with `/implement <app>`; it reads this format.

---

## The documents

| Doc | Answers | Reader | Pace |
|---|---|---|---|
| **ONTOLOGY.md** | What exists, what each thing carries, how things relate, the rules, the interface | Implementer | The real spec. Consulted constantly. |
| **CRITERIA.md** | How we know it's correct, readable, and good | Tester / tuner | Written with the rules; becomes the test file |
| **RATIONALE.md** | Why each choice and number; what's still open | Designer / tuner | A decision journal, appended as things change |
| **DYNAMICS.md** *(games / emergent systems)* | Why it's fun; drivers, strategies, anti-strategies | Designer | Heavy at design time, mostly dormant after |
| **ARCHITECTURE_LOG.md** *(optional)* | Structural changes to the code | Next maintainer | One line per change, **in the same change** |

Purpose (the old TELOS) lives at the top of ONTOLOGY as §0, so the tiebreaker sits on top
of the implementation reference. Don't write a separate TELOS file.

### Tags used everywhere

- **[D]** decided by the designer (the user). Only the user can make something [D].
- **[P]** proposed by Claude, pending review. Never silently promote a [P] to a rule.
- **[T]** tunable number, expected to change under measurement or playtest.
- **Serves:** what an entity or rule exists *for* — a §0 goal (G1…), a §0 feeling/quality,
  or a DYNAMICS driver. An item that serves nothing is a candidate for cutting; a goal that
  nothing serves is unmet.
- **IDs:** goals `G-n`, decisions `D-n`, open questions `Q-n`, criteria `R-n` / `U-n` / `X-n`.
  IDs are never reused or renumbered; a resolved Q becomes a D that says "(resolves the
  former Q-n)".

---

## ONTOLOGY.md

Header: one paragraph saying this is the implementation reference, links to the other
docs, and the tag legend.

### §0 Purpose **[D]**
What the thing is *for*, in one or two sentences. Then:
- **Qualities / feelings** the user should experience (named, so Serves tags can cite them).
- **Goals** `G1…` in priority order, each one line plus what it means concretely.
- **Priorities when goals conflict** — explicit ordering.
- **Non-goals (for now)** — what we're deliberately not doing.

This section breaks ties between docs and decides whether new ideas belong.

### §1 Entities
One subsection per entity. Each has a *Serves:* line and a **field table**:

| Field | Type | Notes |
|---|---|---|

Every piece of state has a named home here ("state must fit in a struct"). If a mechanic
needs state with no home, the mechanic is vague or the model is incomplete — fix one.
Mark state that exists only for generation/setup, and drop it after use if nothing reads it.
Prefer **templates over snowflakes**: content that varies (items, units, abilities) is a
parameter set for a small number of templates, not a unique type each.

Include the top-level world/state struct with every field.

### §2 Relations and invariants
Bulleted statements that must always hold (cardinalities, ranges, conservation laws,
"X never reads Y", determinism: "same seed + same commands = same state"). Each invariant is
a candidate R-criterion.

### §3… Domain-specific structure
Terrain, schemas, state machines — whatever the domain needs, each with Serves and tags.

### §4 Rules
One subsection per rule, each with *Serves:* and a status tag, then **≤5–10 lines of
pseudocode** in a code block: legality check, state mutation, what ends/triggers what.
If a rule can't be written as short pseudocode, it's too vague to implement. Prefer one code
path for all cases over special-case branches. Bake costs into the system that governs the
action (e.g. into the movement cost) rather than bolting on a separate check. When a rule
has been measured, note the measurement next to its Serves line.

### §5 Agents / automation *(if any)*
Any non-player actor (AI, scheduler, background job) under the **same rules** as the user,
with explicit information limits (what it can see/know) and commitment patterns.

### §6 Numbers **[T]**
One table of every tunable constant: name, value, unit, decision ID. **Elsewhere in the
docs, refer to constants by name (`HEARING`), never by value.** The code constant is the
single source; ideally a small script regenerates this table from code. RATIONALE may quote
values because it records history.

### §7 Commands and events (the interface) — write before the engine
This is the API between core and any client (UI today, network tomorrow), and the thing
that lets a UI animate. It is the part most often invented during implementation; don't
let it be.
- **Commands:** table of `command(args)` | legal when | effect | side effects (ends turn,
  etc.). Every command re-checks legality itself; illegal → `{ ok: false }`, no change.
  Legal → a uniform result shape (e.g. `{ ok, events, ... }`).
- **Read-only queries** clients may call. Previews must call the same rule functions as the
  engine, so the preview *is* the rule.
- **Events:** table of event type | fields | who learns of it (visibility rules).
- The **client contract**: what the UI may and may not reach into.

---

## CRITERIA.md

Three kinds, each a table, each row with an ID:

- **R — Rules (automated).** `ID | Given | Expect`. Concrete inputs and outputs, including
  edge cases and monotonicity/invariant checks. Cite the ONTOLOGY section.
- **U — UI / readability (manual or scripted).** One observable criterion per row.
- **X — Experience / outcomes (measured or playtested).** `ID | Criterion | Linked decision`.
  Phrase each so it can fail ("fails if it misses in most of N runs").

**Every row names its instrument**: a labeled test assertion, a soak/self-play metric, a
committed browser script, or a human playtest question. A criterion with no instrument is
a wish — either give it one or say "human playtest" explicitly.

Rules for the tests:
- Label each assertion with its ID (`R-12 …`).
- The test **fails if any R-ID in CRITERIA has no labeled assertion** (coverage check).
- Keep a **Status** section at the bottom: date, pass counts, per-U and per-X results with
  the command that produced them, and what still needs a human.

---

## RATIONALE.md

Grouped by topic. Each decision:

```
### D-n Short statement of the decision — *Decided | Proposed | Proposed, tuned by <instrument>*
- **Alternatives:** what else was considered.
- **Why:** the reason, citing goals/drivers. (Writing alternatives is what finds bugs.)
- **Tuning:** before → after, and why it moved.
- **Evidence:** `Measured by: <command> → <result>` or
                `Modeled by: <sim/arithmetic> (unverified in play)`.
```

- **Never state a modeled number as a fact.** Predicted outcomes are marked "to be set by
  measurement" until measured.
- Attribute a change only through a **controlled comparison**, one variable at a time. If
  three numbers changed together, the attribution is confounded; say so.
- **Open questions** `Q-n`: each with the options and Claude's recommendation. Batch them to
  the user in **one message**; resolved ones move to decisions.
- **Deliberately left out:** things considered and excluded, so they aren't re-proposed.

---

## DYNAMICS.md (games and emergent systems)

Follow the `game-design` skill for the content (theme → 2–3 drivers → one key mechanic per
driver → secondary mechanics woven in → gut check). This skill adds:
- Mark every number **[T]**; DYNAMICS refers to constants by name.
- **Strategies**: phases, recurring tensions, and an **anti-strategy table** where every row
  names the *specific mechanical prevention*. "It would be boring" is not a prevention.
  Unprevented anti-strategies become Q-items.
- A **strategy ↔ mechanic cross-check**: every strategy uses real rules; every rule is used
  by some strategy.

For non-game systems, the equivalent is a short "how it's used / how it's abused" section
with the same prevention discipline.

---

## Order of work

1. **Purpose and intent with the user.** §0 (and DYNAMICS for games) through a short Q&A.
   Tag everything. Mark all numbers [T].
2. **ONTOLOGY and CRITERIA R-tables together**, including §7 commands and events. Write each
   rule next to its test case.
3. **RATIONALE** for every [D] and [P], with alternatives. Collect Q-items and **send them to
   the user in one batch**. Stop on anything blocking.
4. Hand off to **`/implement`**: contract → headless core + tests (seeded, DOM-free) →
   measure and tune with a **committed** harness → UI verified by a **committed** browser
   script.
5. **Measure before claiming.** No balance claim enters RATIONALE without Evidence.
6. **Reconcile docs in the same change as the code.** For each changed rule or number:
   ONTOLOGY rule + RATIONALE entry + CRITERIA row/status + test assertion, together.
7. **Human checks** against the X-items no instrument can answer, then a RATIONALE pass on
   what the measurements couldn't tell.

---

## Teleology review

Periodically — after tuning or a major design change — ask of each item: **does it still do
what its Serves tag says?** Mechanics drift: a rule built for one purpose ends up measurably
serving another, or nothing.

1. List every entity/rule with its stated purpose.
2. **Measure** what it actually does (toggle it, halve/double it, add a metric to the
   committed harness). Reading code isn't evidence; name the command for every finding.
3. Table: `# | Item | Stated purpose | What it actually does | Verdict` with verdicts
   **Served / Half drifted / Drifted / Unverified / Wording drift / Nit**.
4. Also check the reverse: goals and qualities nothing serves, and purposes with no state
   home.
5. Write recommendations, but **leave design fixes to the user**. Fix only wording and
   obvious doc errors directly. Update Serves tags to say where measurement shows drift.

Save as `docs/TELEOLOGY_REVIEW.md` (dated).

---

## Pitfalls (learned the hard way)

- **Duplicated numbers.** The same constant in five docs means every tuning change is a hunt.
  Use names, keep one source.
- **The missing interface.** Commands/events get invented during coding unless §7 is written
  first.
- **Untestable criteria.** "AI uses only what it sees" needs a designed assertion, not a
  hope. The ID coverage check catches the omission.
- **Throwaway tools.** The tuning harness and browser driver produce the most important
  findings; commit them so the loop is repeatable.
- **Confident predictions.** A one-on-one simulation predicted 4–8 shots; the real ecology
  gave 2. Label modeled numbers.
- **Logs written after the fact** aren't logs. One line per structural change, in that change.
- **Doc sprawl.** Each doc must have a distinct reader. If two docs describe the same thing,
  fold one into the other (as TELOS was folded into ONTOLOGY §0).

## Example usage

```
/ontology_spec new app: <one-line idea>
/ontology_spec survive        # review / extend an existing set
/ontology_spec teleology survive
```
