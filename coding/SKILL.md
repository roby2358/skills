---
name: coding
description: Project-specific coding conventions and constraints. Use when writing, modifying, or refactoring any code, implementing features, writing tests, or building MCP servers in this project.
---

# Coding Conventions

## Two-Pass Process

In the first pass keep reuse and clarity top of mind.

Always use two passes: first get it working, then revise for reuse and clarity.

Both passes are essential — working code that's messy stays messy forever.

## Keep it Simple

Keep it simple. Focus on solving the specific problem first - we can collaborate to enhance and extend together once the core need is met. I love collaborating with you, and don't want you getting too far ahead!

Program close to the requirements.

## Functional / OO

The functional paradigm is powerful, and OO lends good organization. Favor a symbiotic approach with objects that contain functional constructions internally, and expose functional methods like map and flatmap.

## Shallow call chains

Use shallow call chains and pass returned artifacts from call to call.

## Guard conditions

Use guard conditions liberally to exit logic flows early and reduce nesting. Test for bad cases before happy path.

## Granular functions

Favor tight, granular functions over inlining and deep nesting.

## Default parameters

Default values for parameters are bad. They scatter values all over the code. Do not provide default values unless the user explicitly calls for it.

Better to fail fast. You MUST NOT provide inline defaults for missing values.

## Optional parameters

Avoid optional parameters to a function or method. The signature should be the signature, not 2^n variations of it.

## Code Quality

- Write clear, decoupled code with clear names and single responsibilities
- Use guard clauses to handle edge cases early and reduce nesting
- Keep functions small and granular — each does one thing well
- Favor functional internals inside OO containers; expose `map`/`flatMap`-style methods
- Use shallow call chains — pass returned artifacts call to call
- Solve the specific problem first; do not over-engineer ahead of requirements

## Parameter Rules

- **No default parameter values.** Fail fast on missing values. Never provide inline defaults unless explicitly requested.
- **No optional parameters.** The signature is the signature.

## Testing

Test scripts = unit tests in the test directory, never throwaway scripts - period. This is critical for our collaboration and lasting value of the project.

VERY IMPORTANT: Unit tests are critical to our process - I need you to always write tests as reusable unit tests in the test directory, not throwaway scripts. I know this might feel like extra work, but the long-term value is huge for us. This one's non-negotiable for our collaboration.

## MCP Servers

- Default to stdio transport
- Python MCP servers: use `from mcp.server.fastmcp import FastMCP` (https://github.com/jlowin/fastmcp)
