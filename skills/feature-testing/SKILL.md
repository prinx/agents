---
name: feature-testing
description: Use when validating a completed feature against its acceptance criteria through integrated behavior.
---

# Feature Testing

Validate that the completed feature works as intended from a user's perspective, covering normal flow, failure paths, and relevant edge cases. Feature tests bridge the gap between unit tests and full end-to-end tests.

## When to write

- **New feature**: after unit tests pass, verify the feature meets each acceptance criterion through observable behavior.
- **Bug fix**: verify the original broken behavior is fixed and the surrounding feature still works correctly.
- **Changed behavior**: re-test affected acceptance criteria when existing behavior is modified.

## What to test

- **Acceptance criteria**: map every criterion from the ticket to an observable behavior and verify it.
- **Normal flow**: the happy path a user would follow to accomplish the goal.
- **Failure flow**: what happens when the user provides invalid input, is unauthorized, or a dependency fails.
- **Validation paths**: form validation, API validation, permission checks, boundary conditions.
- **UI-specific checks** (when applicable):
  - Keyboard navigation: tab order, enter/space activation, escape to close.
  - Accessible names: buttons and inputs have meaningful labels or aria-labels.
  - Responsive behavior: layout works at common breakpoints (mobile, tablet, desktop).
  - Visual states: loading, empty, error, success states are all handled.
- **Integration points**: correct data flow between components, modules, or services involved in the feature.

## What not to test

- Internal implementation details (which function was called, how state is stored).
- Third-party service behavior (mock those; test your integration contract).
- Areas unrelated to the feature scope.

## How to write

- Use the project's existing test framework for automated feature tests when available.
- For manual feature tests, write short reproducible steps with expected outcomes.
- Each test should map to exactly one acceptance criterion or risk area.
- Include both positive and negative cases.
- Keep the test scope bounded to the feature; do not expand into unrelated areas.

## Running

- Run the relevant feature test command if the project has one (integration tests, API tests, component tests).
- For manual checks, execute each step and record the actual result.
- Record the exact command or steps run and their outcomes.

## Evidence for quality

Give quality the list of acceptance criteria tested, the method used (automated or manual), actual results for each, and any criteria that could not be verified. Do not invent results. Keep the evidence concise and factual.
