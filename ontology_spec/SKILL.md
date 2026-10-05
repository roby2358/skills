---
name: ontology_spec
description: Write and maintain an ontology-based design-doc set (ONTOLOGY.md + CRITERIA.md + RATIONALE.md + ARCHITECTURE_LOG.md, plus DYNAMICS.md for games) instead of a single SPEC.md. ONTOLOGY is the implementation reference — purpose, entities as structs, invariants, rules as short pseudocode, commands and events, numbers — with provenance tags ([D]/[P]/[T]) and Serves tags; CRITERIA turns every rule into input → expect rows, each owning a test directory; RATIONALE records the why of current decisions with alternatives and evidence; ARCHITECTURE_LOG holds the dated history. Use when starting a new app, game, or major system, when converting an existing SPEC.md into this format, when the user says "ontology", "/ontology_spec", or asks for design docs where the *why* matters. Also use for a teleology review (does each thing still do what it's for?).
---

# Ontology Spec

A design-doc set that separates **what exists and how it behaves** (ONTOLOGY), **how we
know it's right** (CRITERIA), **why each choice was made** (RATIONALE), and **how it got
here** (ARCHITECTURE_LOG). For games and other systems with emergent behavior, add **why
it's fun / why it works** (DYNAMICS).

The gains come from four properties, not from the number of files:
1. **Tagged provenance** — the designer's decisions are never confused with Claude's guesses.
2. **Rationale with alternatives** — writing down what else was considered finds bugs.
3. **Criteria as tables** — rules arrive with their test cases, so tests are transcription.
4. **Stable IDs** — code, tests and docs cite `G-n`/`D-n`/`Q-n`/`R-n`, which never move.

If a project is a small CRUD feature, use the `specification` skill (SPEC.md) instead, and
borrow these properties as sections. Use this format when the *why* matters as much
as the *what*: games, simulations, rule engines, protocols, security services, anything
that will be tuned.

After the docs exist, build with `/implement <app>`; it reads this format.

---

## The documents

| Doc | Answers | Reader | Pace |
|---|---|---|---|
| **ONTOLOGY.md** | What exists, what each thing carries, how things relate, the rules, the interface | Implementer | The real spec. Consulted constantly. |
| **CRITERIA.md** | How we know it's correct, readable, and good | Tester / tuner | Written with the rules; each row owns its tests |
| **RATIONALE.md** | Why each current choice and number; what's still open | Designer / tuner | Edited as decisions change |
| **ARCHITECTURE_LOG.md** | What changed, when, why, and what it replaced | Next maintainer | A dated entry **in the same change** |
| **DYNAMICS.md** *(games / emergent systems)* | Why it's fun; drivers, strategies, anti-strategies | Designer | Heavy at design time, mostly dormant after |

**Every doc except ARCHITECTURE_LOG describes the current state only.** No "formerly",
"originally named", "(resolves the former Q-n)", "reversed in March", tuning before → after,
or spec-vs-code discrepancy notes outside the log. RATIONALE keeps the *why* of what is
true now (alternatives, evidence); the log keeps the story of how it changed. A reader of
ONTOLOGY should never have to subtract history to find the truth.

Purpose (the old TELOS) lives at the top of ONTOLOGY as §0, so the tiebreaker sits on top
of the implementation reference. Don't write a separate TELOS file.

### Tags used everywhere

- **[D]** decided by the designer (the user). Only the user can make something [D].
- **[P]** proposed by Claude, pending review. Never silently promote a [P] to a rule.
- **[T]** tunable number, expected to change under measurement or playtest.
- **Serves:** what an entity or rule exists *for* — a §0 goal (G-1…), a §0 feeling/quality,
  or a DYNAMICS driver. An item that serves nothing is a candidate for cutting; a goal that
  nothing serves is unmet.
- **IDs:** goals `G-n`, decisions `D-n`, open questions `Q-n`, criteria `R-n` / `U-n` / `X-n`.
  IDs are never reused or renumbered. A resolved Q becomes a D (or is dropped); the log
  entry records which Q it settled. A removed criterion stays as a `retired` tombstone row
  so its ID can't be reissued.

### Citations

**Cite stable IDs, never section numbers.** Code comments, tests, commit messages, tracker
tickets and the docs themselves say `D-17`, `R-12`, `G-2`. Section numbers move whenever a
doc is reorganized, and every `§4.3` back-reference silently breaks — a long spec can
accumulate hundreds. Inside the doc set, prefer naming the target ("the OTT consume rule")
over `§4.1`; a CRITERIA row that cites ONTOLOGY by section number has the same fragility,
so if you use them, sweep them whenever ONTOLOGY's sections move.

---

## ONTOLOGY.md

Header: one paragraph saying this is the implementation reference, and the tag legend.

### §0 Purpose **[D]**
What the thing is *for*, in one or two sentences. Then:
- **Qualities / feelings** the user should experience (named, so Serves tags can cite them).
- **Goals** `G-1…` in priority order, each one line plus what it means concretely.
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

Include the top-level world/state struct with every field. For a service, this is the
canonical vocabulary: one name per concept, used the same way in code, schema and docs.

### §2 Relations and invariants
Bulleted statements that must always hold (cardinalities, ranges, conservation laws,
"X never reads Y", determinism: "same seed + same commands = same state"). Each invariant is
a candidate R-criterion.

### §3… Domain-specific structure
Terrain, schemas, state machines, token formats — whatever the domain needs, each with
Serves and tags.

### §4 Rules
One subsection per rule, each with *Serves:* and a status tag, then **≤5–10 lines of
pseudocode** in a code block: legality check, state mutation, what ends/triggers what.
If a rule can't be written as short pseudocode, it's too vague to implement. Prefer one code
path for all cases over special-case branches. Bake costs into the system that governs the
action (e.g. into the movement cost) rather than bolting on a separate check. When a rule
has been measured, note the measurement next to its Serves line.

Background jobs (retention sweeps, expiry, bootstrap scripts) are rules too: they mutate
state, so they get pseudocode and a criterion.

### §5 Agents / automation *(if any)*
Any non-player actor (AI, scheduler, background job) under the **same rules** as the user,
with explicit information limits (what it can see/know) and commitment patterns.

### §6 Numbers **[T]**
One table of every tunable constant: name, value, unit, decision ID. **Elsewhere in the
docs, refer to constants by name (`HEARING`), never by value.** The code constant is the
single source; ideally a small script regenerates this table from code. Tests refer to the
constant by name too. RATIONALE may quote a value as evidence for the current choice;
earlier values belong in the log.

### §7 Commands and events (the interface) — write before the engine
This is the API between core and any client (UI today, network tomorrow), and the thing
that lets a UI animate. It is the part most often invented during implementation; don't
let it be. For a service, this is the endpoint table.
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

- **R — Rules (automated).** `ID | Given | Expect | Instrument`. Concrete inputs and
  outputs, including edge cases and monotonicity/invariant checks. One row per rule, at the
  level of the rule — the individual cases live in the tests, not in the table.
- **U — UI / readability (manual or scripted).** One observable criterion per row.
- **X — Experience / outcomes (measured or playtested).** `ID | Criterion | Linked decision`.
  Phrase each so it can fail ("fails if it misses in most of N runs").

**The Instrument column is the row's status**, one of exactly four forms:
- `automated` — tests exist and run in the normal test command;
- `manual — <what a human checks>`;
- `not yet covered` — a known gap;
- `retired` — a tombstone; the ID is never reused.

A criterion with no instrument is a wish — mark it `not yet covered` rather than pretend.

### Tests: the directory is the label

- Each `automated` R-row owns a directory **`test/R-n/`** (capital R, no zero padding;
  numbers carry no meaning, so lexical order doesn't matter). Files inside are named for
  what they check. Don't list test files in CRITERIA — the directory is the link, and the
  detail of each case is commented in the test itself.
- **Each test asserts exactly one rule.** A test that checks two rules is split, with the
  shared setup moved to a helpers directory. A happy-path walkthrough that touches many
  rules is an integration test and lives outside the `R-n` directories.
- Tests that check no rule stay in ordinary `unit/` / `integration/` directories.
- A **coverage test** runs with the suite and fails when an `automated` row has no
  `test/R-n/` with a test in it, when a `test/R-n/` exists for a row that is missing or not
  `automated`, or when an Instrument cell isn't one of the four forms.
- **Time-dependent rules** (sliding windows, TTLs, buckets, expiry): pin the clock in the
  test (fake timers set to a window/bucket start). A real-time burst that straddles a
  boundary flakes intermittently, usually under load.

### Status

Keep a **Status** section at the bottom: date; what is not yet covered, manual only, or
retired; and **partial coverage, honestly** — each `automated` row whose tests miss part of
the Expect column, with the missing part named. Every gap listed there becomes a tracker
ticket. Pass counts come from the test command and don't need to be copied in.

---

## RATIONALE.md

Grouped by topic. Each decision describes the choice as it stands now:

```
### D-n Short statement of the decision — *Decided | Proposed | Proposed, tuned by <instrument>*
- **Alternatives:** what else was considered.
- **Why:** the reason, citing goals/drivers. (Writing alternatives is what finds bugs.)
- **Evidence:** `Measured by: <command> → <result>` or
                `Modeled by: <sim/arithmetic> (unverified in play)`.
```

- **Never state a modeled number as a fact.** Predicted outcomes are marked "to be set by
  measurement" until measured.
- Attribute a change only through a **controlled comparison**, one variable at a time. If
  three numbers changed together, the attribution is confounded; say so (in the log entry
  that records the change).
- **Open questions** `Q-n`: each with the options and Claude's recommendation. Batch them to
  the user in **one message**; resolved ones become decisions, and the log records it.
- **Deliberately left out:** things considered and excluded, so they aren't re-proposed.
- **How it's used / how it's abused** (non-game systems; see DYNAMICS for games): a short
  paragraph of normal use, then a table `Abuse | Prevention | Criteria` where every row
  names the specific mechanical prevention and the R-rows that test it. This is the threat
  model. An abuse with no prevention is either an explicit non-goal from §0 or a Q-item.

---

## ARCHITECTURE_LOG.md

Dated entries, **newest first**, one per structural or design change:

```
### YYYY-MM-DD — What changed, in one line
What it replaced, why, and which IDs it touched (Q-n settled by D-n, R-n retired, constant
X moved from A to B and why). A few sentences, not an essay.
```

Write the entry **in the same change** as the code and docs; a log written after the fact
isn't a log. This is the only doc that may say "formerly". The tracker's done list is not a
substitute — tickets record work, the log records the design.

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
   ONTOLOGY rule + RATIONALE entry + CRITERIA row/status + `test/R-n/` + log entry, together.
7. **Human checks** against the X-items no instrument can answer, then a RATIONALE pass on
   what the measurements couldn't tell.

---

## Converting an existing spec

When the project already has a SPEC.md (or several), the job is translation, not design.

1. **Map first.** Read the whole spec and the code, then write an old-section → new-ID map
   (spec §4.2 → ONTOLOGY rule + R-7 + D-12). It drives the rewrite and the back-reference
   sweep, and shows anything that has no home.
2. **Code wins.** Specs drift. Where spec and code disagree, ONTOLOGY describes the code,
   and each discrepancy goes in a list for the user (and, once accepted, in the log) — never
   silently "fixed" in either direction.
3. **Tag honestly.** Shipped behavior the user designed is [D]. Claude's inferences, gap
   fills and proposed fixes are [P]. Number constants found in code are [T] with their code
   names.
4. **Batch the questions.** Discrepancies the user should rule on and gaps worth fixing
   become Q-items, sent in one message with recommendations.
5. **Sweep the back-references.** Find every citation of the old spec's sections in code,
   tests, docs and open tracker tickets and rewrite it to a stable ID. Leave closed/done
   tracker history alone — it's a record of its time.
6. **Retire the old spec** in the same change, with a log entry saying what replaced it.

**Work in small committable slices**, each one green: docs → back-reference sweep → test
reorganization into `R-n` directories → log. Fixes the conversion discovers (bugs, coverage
gaps, open questions the user settles) become **tracker tickets**, not part of the
conversion — it is tempting to fix everything at once and end with one unreviewable change.

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
- **Section-number back-references.** They break on every reorganization. Cite stable IDs.
- **History in the current-state docs.** "Formerly", "resolves the former Q-3" and
  before → after tuning notes accumulate until the reader can't tell what's true now. They
  go in the log.
- **Test lists in two places.** A CRITERIA row that lists its test files drifts from the
  tests. The `test/R-n/` directory is the only link.
- **Tests that straddle rules.** A test asserting two rules makes coverage ambiguous and
  fails for the wrong reason. One rule per test; shared setup in helpers.
- **Real-time tests of time-based rules.** They pass alone and flake under load. Pin the clock.
- **The missing interface.** Commands/events get invented during coding unless §7 is written
  first.
- **Untestable criteria.** "AI uses only what it sees" needs a designed assertion, not a
  hope. The coverage check catches the omission.
- **Throwaway tools.** The tuning harness and browser driver produce the most important
  findings; commit them so the loop is repeatable.
- **Confident predictions.** A one-on-one simulation predicted 4–8 shots; the real ecology
  gave 2. Label modeled numbers.
- **Doc sprawl.** Each doc must have a distinct reader. If two docs describe the same thing,
  fold one into the other (as TELOS was folded into ONTOLOGY §0).
- **One giant change.** A conversion plus every fix it uncovers is unreviewable. Slice it,
  and ticket the rest.

## Example usage

```
/ontology_spec new app: <one-line idea>
/ontology_spec convert docs/SPEC.md   # translate an existing spec into the set
/ontology_spec survive                # review / extend an existing set
/ontology_spec teleology survive
```
