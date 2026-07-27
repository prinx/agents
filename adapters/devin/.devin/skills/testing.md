---
name: testing
description: Three-level testing guidance — unit, feature, and end-to-end tests. Use when writing or running tests.
trigger: When writing tests, running test suites, checking test coverage, or validating test results.
---

# Testing Skill

Work test-first at three levels:

## Unit tests
- Write a focused failing test for the core logic
- Implement the smallest change to make it pass
- Cover edge cases, error handling, meaningful branches
- Run with the project's test runner and record actual output

## Feature tests
- Verify each acceptance criterion through observable behavior
- Test normal flow, failure paths, validation
- For UI: include keyboard, accessible-name, responsive checks
- Record actual results

## End-to-end tests
- Simulate the real user journey in the actual application
- Start the app, run the complete flow, record URL or commands
- Confirm the goal is achieved

## Bug fix regression tests
Write regression tests at each applicable level BEFORE the fix:
1. Unit test that reproduces the bug in logic — confirm it fails
2. Feature test that reproduces broken behavior — confirm it fails
3. E2E test that reproduces the user scenario — confirm it fails
Then fix, then confirm all pass.

Never claim tests pass without running them. Record actual output.
