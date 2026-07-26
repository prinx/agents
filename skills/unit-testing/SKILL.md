---
name: unit-testing
description: Use when creating or running focused automated tests for isolated logic and edge cases.
---

# Unit Testing

Write and run fast, isolated tests for individual functions, methods, classes, or modules. Unit tests verify correctness at the smallest useful boundary without external services, networks, or UI.

## When to write

- **New code**: write a failing unit test before implementation (test-first), then implement the smallest change to make it pass.
- **Bug fix**: write a focused regression unit test that reproduces the bug, confirm it fails, apply the fix, confirm it passes.
- **Changed logic**: update or add unit tests when existing behavior changes.

## What to test

- Core logic: calculations, transformations, validations, state transitions.
- Edge cases: empty input, null/undefined, boundary values, maximum/minimum, off-by-one.
- Error handling: invalid input, missing fields, permission denial, timeout simulation.
- Branch coverage: every meaningful if/else, switch case, try/catch path.
- Pure functions first: they are the easiest to unit test and give the highest confidence per effort.

## What not to test

- Framework boilerplate or trivial getters/setters.
- Third-party library internals (test your integration with them, not their implementation).
- Implementation details that do not affect observable behavior.

## How to write

- Follow the project's existing test framework, file naming, and directory conventions.
- Each test should be independent and runnable in isolation.
- Use descriptive test names that state the scenario and expected outcome.
- Prefer Arrange-Act-Assert or Given-When-Then structure.
- Mock or stub only external boundaries (network, filesystem, database, time); do not mock the unit under test.
- Keep tests fast: if a test needs more than a few seconds, it is likely not a unit test.

## Running

- Use the project's test command (for example `npm test`, `pytest`, `go test`, `cargo test`).
- Run the specific test file or test name when possible for fast feedback.
- Record the exact command run and its output: tests passed, tests failed, any skip or warning counts.

## Evidence for quality

Give quality the actual test command, result summary, and any test files created or modified. Do not claim tests were run if they were not. Keep the evidence concise and factual.
