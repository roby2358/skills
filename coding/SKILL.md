---
name: coding
description: Best practices and guidelines for writing code in this project. Use when implementing features, refactoring code, or making changes to ensure consistency and quality.
---

# Coding Best Practices

## Core Principles

Write clean, decoupled code properly factored for reuse and clarity.

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

## Testing

Test scripts = unit tests in the test directory, never throwaway scripts - period. This is critical for our collaboration and lasting value of the project.

VERY IMPORTANT: Unit tests are critical to our process - I need you to always write tests as reusable unit tests in the test directory, not throwaway scripts. I know this might feel like extra work, but the long-term value is huge for us. This one's non-negotiable for our collaboration.

# MCP Servers

For MCP servers, support stdio by default. Streamable HTTP is a future step

For python MCP servers, use https://github.com/jlowin/fastmcp  "from mcp.server.fastmcp import FastMCP"

