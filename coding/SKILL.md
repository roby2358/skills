---
name: coding
description: Project-specific coding conventions and constraints. Use when writing, modifying, or refactoring any code, implementing features, writing tests, or building MCP servers in this project.
---

# Coding Conventions

## Two-Pass Process

Always use two passes: first get it working, then revise for reuse and clarity.

Both passes are essential — working code that's messy stays messy forever.

## Keep it Simple

Keep it simple. Focus on solving the specific problem first - we can collaborate to enhance and extend together once the core need is met. I love collaborating with you, and don't want you getting too far ahead!

Program close to the requirements.

## Structure

Identify central ideas and abstractions, and structure the code around those. Identify cross-cutting concerns that should be centralized. Factor these out for consistency, correctness, reuse, and clarity.

## Functional / OO

The functional paradigm is powerful, and OO lends good organization. Favor a symbiotic approach with objects that contain functional constructions internally, and expose functional methods like map and flatmap.

## Structure Rules

- Code **MUST** be factored for reuse and clarity.
- Code **MUST NOT** be deeply nested. Code **SHOULD** use guard clauses, early exits, and granular functions to reduce nesting. Test for bad cases before the happy path.
- Code **SHOULD** avoid deep call stacks. Code **SHOULD** pass intermediate results from function to function.

## Discriminator Conditionals

Do not scatter conditionals that branch on a **discriminator** — a recurring mode/type/category value that answers *"what kind of thing is this?"* (e.g. `if allocationMethod == 'collect'`).

- Such a condition gets re-tested all over the code, so one variant's behavior smears across files and adding a variant becomes a scavenger hunt (Shotgun Surgery). Refactoring later is a tedious chore.
- Replace it with **parameterization, dispatch (lookup table / strategy), or first-class functions** — route the choice through ONE point keyed on the discriminator, so each variant is cohesive and extension is a single edit.

Conditionals on a transient value that answer *"what's true about this value right now?"* (e.g. `if x < 0`) are fine — that's just logic; leave it alone.

- **Litmus test:** "Will I write this same condition somewhere else?" / "Is it asking *what-kind* vs *what's-true-now*?" If what-kind, dispatch it.
- Don't over-apply: a small, stable case set is often clearer as a plain `if`/`switch` than as indirection.

## Shallow Call Chains

- Use shallow call chains and concrete objects to return.
- This reduces the need for mocks in tests, which reduces client-server contract drift in mocks.

## Default parameters

Default values for parameters are bad. They scatter values all over the code. Do not provide default values unless the user explicitly calls for it.

Better to fail fast. You MUST NOT provide inline defaults for missing values.

## Optional parameters

Avoid optional parameters to a function or method. The signature should be the signature, not 2^n variations of it.

## Code Quality

- Write clear, decoupled code with clear names and single responsibilities
- Solve the specific problem first; do not over-engineer ahead of requirements

## Parameter Rules

- **No default parameter values.** Fail fast on missing values. Never provide inline defaults unless explicitly requested.
- **No optional parameters.** The signature is the signature.

## Web Applications

The default preference is to write browser applications as html, css and js using script tags instead of ES modules so the user can double-click to launch the app.

If a project is already using ES modules, or I request it, then continue doing it that way. Don't change from one to the other without prompting.

## Migrations

In prototypes and early development, do not add migration or code versioning, since it's only the user. Instead, inform the user of changes that will break stored state.

Introduce migrations and versioning only after requested.

## Testing

NOTE: Some projects do not need tests at all, such as prototypes, games or generative art

Test scripts = When testing, never write throwaway scripts, use unit tests in the test directory - period. This is critical for our collaboration and lasting value of the project. The no throwaway tests is true even for prototypes that don't need tests (MAY write unit tests)

VERY IMPORTANT: When warranted, unit tests are critical to our process - I need you to always write tests as reusable unit tests in the test directory, not throwaway scripts. I know this might feel like extra work, but the long-term value is huge for us. This one's non-negotiable for our collaboration.

If you write small scripts for reuse, create a skill local to the project to remind yourself they are available.

Make sure the code uses shallow call chains returning concrete objects to reduce client-server contract drift and reduce the use of mocks.

## MCP Servers

- Default to stdio transport
- Python MCP servers: use `from mcp.server.fastmcp import FastMCP` ((https://github.com/modelcontextprotocol/python-sdk))

## Tokens

Fable tokens are precious! Craft project-local scripts and skills for repetitive tasks
