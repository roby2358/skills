---
name: horizon
description: Structured pause before building. Use when about to implement a feature, ship a change, or when the user invokes /horizon. Forces examination of what's beyond the immediate solution — whether this should be built at all, whether the design is right, whether existing code needs attention first. Triggers on feature requests, implementation starts, or when the user wants to challenge the impulse to build.
---

# Horizon Check

LLMs have a horizon problem. They optimize for the nearest working solution. So do humans — but LLMs turbocharge the impulse by making the path to "done" feel frictionless. The things that matter most are over the horizon: whether this should exist, whether the design compounds well, whether you're building the right thing next.

This skill is a forcing function. Run it before building, not after.

## Start Here: What am I trying to accomplish?

Before the horizons, before any analysis — answer this in one or two sentences. Not "build feature X" but the business proposition: what outcome are you trying to create and for whom?

This question is both broad and narrow. Broad because it opens the full problem space — you might discover the feature you had in mind isn't even the right shape for the goal. Narrow because once you know what you're actually trying to accomplish, entire solution categories die immediately. You don't have to evaluate them, they're just irrelevant.

If you can't answer this clearly, you are not ready to build anything. Stop and think until you can.

## The Three Horizons

Work through these in order. Each one can kill the task — that's the point.

### Horizon 1: Should this exist?

The easiest feature to maintain is one you never ship. LLMs make it trivial to prompt something into existence, which drops the bar for what gets built. Fight that.

Take your answer from "What am I trying to accomplish?" and pressure-test it:
- Is this the right solution to that goal, or just the most obvious one? What other approaches did you consider?
- What happens if we don't build this? Who notices? Who complains?
- Is this solving a real problem we've observed, or a hypothetical one we've imagined?
- Have you talked to roby/frank/jay about whether this is worth it? If not, stop here. Do not make this decision solo.

A prototype is not a substitute for product thinking. Understanding *why* to build something is worth more than a working demo of something that shouldn't exist.

If you cannot articulate a compelling reason this should exist, stop. The answer is "not yet."

### Horizon 2: Is the design right?

You've decided it's worth building. Now: is the approach sound, or are you about to lock in a design you'll regret?

LLMs can absorb any amount of hackiness — they'll work around a bad design without complaint. This masks the cost. The human who reads this code later (or the LLM that modifies it next month) pays the full price.

Ask:
- Does this fit naturally into the existing architecture, or are you forcing it?
- If this feels hacky, is the hack in the new code or in the original design? If the original design is off, fix the design first.
- Will this make the surrounding code harder to understand or modify?
- What's the simplest version that validates the idea before committing to the full implementation?
- Are you leaving the code better than you found it?

If the honest answer is "this works but it's ugly," that's a signal to refactor before building on top. Do not let the LLM's tolerance for complexity become your tolerance for complexity.

### Horizon 3: Is this the right thing to build *next*?

Even if the feature is worth building and the design is right — is now the time?

LLMs constantly pull toward shipping the next feature. But there's often 100x more value in fixing what you have, cleaning up debt, and improving how you build things.

Ask:
- What's broken or messy right now that would benefit from attention instead?
- Are there existing features that are 80% done and would benefit more from polish than this new thing would from existing?
- Is there cleanup or refactoring that would make this (and everything after it) easier to build?
- Are you building this because it's important, or because it's new and new feels like progress?

If there's meaningful cleanup to do, do that first. Unsexy work compounds.

## How to Use the Output

After working through the three horizons, state one of:

- **Build it.** The feature is worth it, the design is sound, and now is the right time. Summarize the reasoning briefly.
- **Not yet.** Specify what needs to happen first — a conversation with the team, a refactor, cleanup of existing code, or more product thinking.
- **Don't build it.** Explain why. This is a valid and valuable outcome.

## When to Invoke This Skill

- Before starting any new feature
- When you notice yourself (or the LLM) reaching for "just ship it"
- When a task feels easy — ease is where the horizon problem hides
- When you haven't talked to the team about whether something is worth doing
- Periodically, as a check on whether you're building the right things

## A Note

This skill applies equally to the human and the LLM. The human's horizon problem is wanting to see something new and shiny. The LLM's horizon problem is optimizing for the nearest completion. Both need the same discipline: pause, look further, then decide.

The goal is not to stop building. It's to build less, better.
