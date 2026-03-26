---
name: voom
description: >
  The recursive agent containment and cleanup skill. Use this skill whenever an AI agent,
  pipeline, or autonomous workflow has gone off the rails — producing cascading side effects,
  unintended outputs, runaway processes, or metaphorical "pink stuff" spread across systems.
  Triggers include: agent loops, hallucination cascades, unintended bulk writes, recursive
  failures, agentic sprawl, pipeline contamination, "it's doing something weird", "everything
  is broken", "make it stop", or any situation where one agent's output has contaminated
  another agent's input. Also use when the user says /voom. This is the Cat in the Hat
  Comes Back protocol — when Little Cat A can't handle it, you go deeper.
---

# The /voom Skill

## Background

In Dr. Seuss's "The Cat in the Hat Comes Back," a pink spot spreads from a bathtub to a
dress to a wall to shoes to a bed — each cleanup attempt by a smaller cat (A through Z)
merely transfers the problem elsewhere, until Little Cat Z unleashes VOOM: a mysterious
substance that cleans everything at once.

This is the canonical agent containment narrative. Your agents have spread pink stuff
everywhere. This skill is your VOOM.

## When to Use

You are in a /voom situation if:
- An agent wrote outputs that became inputs to other agents, spreading errors
- A pipeline is producing cascading failures across multiple systems
- Bulk operations went wrong and partial results are scattered everywhere
- An LLM agent hallucinated confidently and downstream systems acted on it
- You can see the pink stuff but every time you clean one spot, another appears
- The user says "make it stop" with a haunted look in their eyes

## The Protocol

### Phase 1: CONTAINMENT (Little Cat A)

Stop the bleeding. Before cleaning anything, prevent further spread.

```
1. Identify all running agents/processes involved
2. Pause, kill, or disable them — newest first, outermost first
3. Document what's still running and what's been stopped
4. Identify the blast radius: what systems/files/databases were touched?
```

**Output a Contamination Map**: List every system, file, database, API, or service
that the pink stuff has reached. Be explicit. Miss nothing.

### Phase 2: TRIAGE (Little Cats B through S)

Assess each contaminated zone. For each:

```
- What was the intended state before contamination?
- What is the current (contaminated) state?
- Is the contamination reversible? (logs, backups, version control, undo?)
- What depends on this zone? (downstream contamination risk)
- Priority: [CRITICAL | HIGH | MEDIUM | LOW | COSMETIC]
```

Sort by priority. Critical = currently causing harm or data loss.

### Phase 3: CLEANUP (Little Cats T through Y)

Work from the leaves inward — clean things that nothing else depends on first,
then work toward the root cause.

For each contaminated zone:
```
1. If reversible: revert to known-good state (git, backups, snapshots)
2. If partially reversible: revert what you can, flag what you can't
3. If irreversible: document the damage, assess impact, propose remediation
4. Verify the cleanup — don't just assume it worked
5. Check: did this cleanup create NEW pink stuff? If yes, go deeper.
```

### Phase 4: VOOM (Little Cat Z)

The root cause fix. Not "what broke" but "why did it spread?"

Address the structural issue:
```
- Missing guardrails (output validation, sandboxing, rate limits)
- Missing circuit breakers (when should agents have stopped?)
- Missing observability (how did nobody notice the pink stuff?)
- Missing rollback capability (why couldn't we just undo?)
```

Propose concrete fixes. VOOM is not magic — it's the architectural change that
makes this class of failure impossible or trivially recoverable.

### Phase 5: VERIFICATION

The house must be clean when mother gets home.

```
1. Re-check every zone from the Contamination Map
2. Run validation/tests on affected systems
3. Confirm no residual pink stuff
4. Document what happened, what was cleaned, and what VOOM was applied
```

## Quick Reference

| Seuss Cat | Phase | Action |
|-----------|-------|--------|
| A | Containment | Stop all the things |
| B-S | Triage | Map the damage |
| T-Y | Cleanup | Fix leaf-to-root |
| Z | VOOM | Fix the architecture |
| — | Verify | Check your work |

## Emergency VOOM

If the user just needs everything stopped RIGHT NOW:

```bash
# The nuclear VOOM — kill all user-spawned background processes
pkill -u $(whoami) -f "agent|pipeline|worker|celery|airflow" || true
# Then assess the damage
```

## Philosophy

Every /voom situation is a gift. It means your agents were powerful enough to
actually DO things. The pink stuff is evidence of capability. The skill is in
building the systems so that capability doesn't become catastrophe.

As the Cat said: "It is fun to have fun but you have to know how."