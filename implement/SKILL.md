---
name: implement
description: Implement an app from its design docs, either a SPEC.md or the ONTOLOGY.md + CRITERIA.md set (with DYNAMICS and RATIONALE), in order (contract, then headless core and tests, then tuning, then UI), then review JS and CSS and reconcile the docs. Use after creating or updating a SPEC.md or ONTOLOGY.md.
---

# Implement Workflow

Build an app from its design documents in a fixed order: contract and tests first, then the
headless core, then measured tuning, then UI, then reviews and doc reconciliation. Use
subagents for the review tasks.

## Required Input

An app path (e.g. `balance`, `survive`, or a full path).

## Step 0: Find the spec format

Look in the app directory:

| Found | Format | Implementation reference | Checks come from | "Why" lives in |
|---|---|---|---|---|
| `ONTOLOGY.md` | **Design-doc set** | ONTOLOGY (§0 purpose / goals / priorities / non-goals, then entities, state, rules as pseudocode, commands and events, numbers) | CRITERIA (R-* rule tables, U-* UI checks, X-* playtest criteria) | RATIONALE (D-* decisions, Q-* open questions); DYNAMICS for intent; ONTOLOGY §0 (or a legacy TELOS.md) breaks ties |
| `SPEC.md` only | **SPEC** | SPEC.md | SPEC's acceptance / examples sections, or derived from its rules | SPEC's notes, if any |
| Neither | Stop | Ask the user to write a spec first (`specification` or `game-design` skill) | | |

If both exist, ONTOLOGY wins; treat SPEC.md as legacy and say so.

## Step 1: Pre-flight (do not write code yet)

- **Open questions.** Read RATIONALE's Q-* list (or SPEC's open questions). If any are
  unanswered and block a rule, batch them to the user in one message and stop.
- **Provenance.** Treat items tagged **[P]** (proposed by Claude) as provisional and
  **[T]** as tunable. Never promote a guess to a rule silently. In a SPEC, note assumptions
  you make in the final report.
- **Contract.** Check that the spec defines the command/action interface and the
  events/results it returns (ONTOLOGY "Commands and events" section, or SPEC API section).
  If it's missing, write it into the spec now, before the engine. It is the API between
  core and UI and the thing that lets the UI animate.
- **Checks.** Check that every rule has a test case written as input → expect. If CRITERIA
  (or SPEC) lacks them, add them now, next to the rule they check.

## Step 2: Core + tests, no UI

- Implement the rules/engine as DOM-free code with seeded randomness, so runs reproduce.
- Write the automated tests by transcribing the criteria tables. With a SPEC.md, label each
  assertion with its criterion ID (`R-12 …`) and fail if any ID has no labeled assertion.
  With the design-doc set, follow ontology_spec's CRITERIA layout: each `automated` R-row's
  tests live in `test/R-n/`, one rule per test, plus the coverage test over the Instrument
  column.
- Run the tests until they pass before touching UI.

## Step 3: Measure before claiming (games and simulations)

Skip this step for apps with no balance or emergent behavior.

- Build a self-play / soak harness as a **committed tool** (e.g. `tools/tune.js`) that
  accepts config overrides on the command line and prints the metrics the X-* criteria name.
  Don't leave it in a scratch directory.
- Tune by comparing configurations, **one variable at a time**. A changed number is
  attributed only by a controlled comparison.
- Record each tuning decision in RATIONALE with an **Evidence** line: `Measured by: <command>
  → <result>` or `Modeled by: <sim> (unverified in play)`. Never state a modeled number as
  fact.

## Step 4: UI

- Build the client on the command/event contract; the UI never reaches past it into rules.
- Templates: follow the app's existing base or fork (e.g. a game forked from
  `hexandcounter`: plain-script globals, State / Engine / Board / UI split). Otherwise, use
  the `description` app for HTML structure (`index.html`), CSS patterns (`index.css`: CSS
  variables, dark theme, `.box`), and JS patterns (`index.js`: `$.yuwakisa.[AppName]`
  constructor).
- Verify with a **committed browser script** (e.g. `test/browser.js`, Playwright) that loads
  a seeded page (`?seed=N`), walks every screen against the U-* criteria, saves
  screenshots, and fails on console errors. Look at the screenshots.

## Step 5: Reviews (run in parallel subagents after Step 4)

**Task A: Review JS for clarity**
- Follow coding standards from the `coding` skill.
- Look for redundant code, unclear naming, missing guard conditions. Make edits.
- Re-run the tests afterwards.

**Task B: Review and clean CSS**
- Compare against the app's base, or `description/index.css`.
- Remove unused rules and redundant properties; ensure consistent variable usage.

**Task C: Reconcile the docs with the code**
- **SPEC format:** update SPEC.md with features, error handling, and UI details that
  emerged, following the `specification` skill.
- **Design-doc format:** for every rule or number that changed, update ONTOLOGY (the rule),
  RATIONALE (why, with Evidence), CRITERIA (the check and its status), and the tests in
  `test/R-n/` **together**. Refer to constants by name where possible, not by value; the code
  constant is the one source. Add a dated ARCHITECTURE_LOG entry (newest first) for each
  structural or design change; the other docs stay current-state only.
- Update CLAUDE.md / README run instructions for any new test or tool.

## Step 6: Report

- Tests and browser checks passed or failed, with counts.
- Tuning results and what was measured vs. modeled.
- Assumptions made ([P] items and SPEC gaps) for the user to confirm.
- The X-* criteria no instrument can check, phrased as **human playtest questions**.

## Example Usage

```
/implement balance
/implement survive
```
