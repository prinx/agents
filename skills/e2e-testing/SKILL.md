---
name: e2e-testing
description: Use when a user journey or cross-service behavior needs end-to-end validation.
---

# End-to-End Testing

Simulate a real user interacting with the application from start to finish. E2E tests run against the actual application (browser, CLI, or API server) with real or realistic dependencies, verifying that the full user journey works.

## When to write

- **New feature**: after unit and feature tests pass, verify the complete user journey works end-to-end.
- **Bug fix**: reproduce the exact user scenario that triggered the bug, confirm the fix works in the real application.
- **Cross-service changes**: when changes span multiple components, modules, or API endpoints, verify the full flow.

## What to test

- **Complete user journey**: every step a real user would take from entry to goal completion.
- **Realistic environment**: run against the actual application (local dev server, test server, or staging), not mocks.
- **Data flow**: verify data persists and flows correctly through the full stack (frontend to database, API to UI, CLI to file system).
- **State transitions**: confirm the application state changes correctly at each step (created, submitted, processed, completed).
- **Error recovery**: verify the user can recover from errors in the real application (retry, go back, correct input).
- **Cross-browser/cross-platform** (when applicable): test at least the primary browser or platform the feature targets.

## What not to test

- Unit-level logic (covered by unit tests).
- Implementation details or internal state.
- Third-party service internals.
- Every edge case (save those for unit tests; E2E focuses on critical paths).

## How to set up

- Determine the actual start command for the application (for example `npm run dev`, `docker compose up`, `python manage.py runserver`).
- Identify the URL or port the application runs on.
- Determine any setup needed: database migration, seed data, environment variables.
- Use the project's existing E2E framework if available (for example Playwright, Cypress, Puppeteer, Selenium, httpx, curl for APIs).
- If no E2E framework exists, use manual simulation with exact steps and record the process.

## How to write

- Each test should represent one complete user journey, not a single assertion.
- Use the actual application UI, API, or CLI as the user would.
- Start from a known state (clean database, fresh session, or documented starting conditions).
- Include cleanup steps to restore the application to a usable state.
- Keep the journey focused: test the smallest meaningful complete flow, not the entire application.

## Running

- Start the application with its actual start command.
- Wait for it to be ready (check the URL responds, server logs show ready, or port is listening).
- Execute the user journey step by step.
- Record the actual URL, port, or CLI command used.
- Record the outcome of each step.
- Stop or clean up the application when done.

## Evidence for quality

Give quality the exact start command, URL or port, step-by-step journey with actual outcomes, any failures encountered, and the cleanup command. If E2E testing is not possible (missing framework, no running application, infrastructure dependency), state exactly what prevents it and what would be needed. Do not invent E2E results. Keep the evidence concise and factual.
