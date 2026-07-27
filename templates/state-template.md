# Workflow State

## Current request

## Selected path

## Delivery mode

Default: `prototype-first`.

## Current ticket and owner

## First feature and approval

## Handoffs and approvals

## Completed features

Log each completed feature here. Keep it compact — one block per feature. This is the orchestrator's memory across features.

For each completed feature, record:
- **Feature name**: short identifier (e.g., "user login", "link shortener")
- **Key decisions**: stack choices, architecture decisions, design tradeoffs
- **Known issues**: bugs found but not fixed, technical debt introduced, limitations
- **Dependencies**: what this feature depends on, what depends on it
- **QA outcome**: PASS, PASS_WITH_NOTES, or BLOCKED with reason

Example:
```
### Feature: user login
- Decisions: JWT tokens, 24h expiry, bcrypt for passwords
- Known issues: rate limiting not yet implemented
- Dependencies: none (first feature)
- QA: PASS
```

## Context window

When starting a new feature, the orchestrator reads the last 2-3 completed features from the log above. This provides continuity:
- What decisions were made that affect the new feature?
- What known issues might interact with the new feature?
- What dependencies exist?

Keep the context window short — 2-3 features is enough. Older features stay in the log for reference but are not actively loaded.

## Next action

At feature completion, record the user's choice: test, fix, adjust, or next feature.
