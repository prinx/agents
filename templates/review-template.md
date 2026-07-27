# Review

## Outcome: APPROVE or REQUEST CHANGES

## Ticket and diff reviewed

## Blocking findings

List each finding that requires a change before merge. For each:
- What the issue is
- Where in the diff it occurs
- Why it matters
- What change is needed

## Advisory findings

List findings that should be addressed but are not blocking. For each:
- What the issue is
- Where in the diff it occurs
- Why it matters
- Suggested change

## Security

Any security-relevant observations from the diff inspection.

## Risk-triggered security and accessibility review

State `Not triggered` or, for each trigger, record the trigger, evidence checked, result, and remaining risk. Security triggers: authentication, authorization, sessions, secrets/credentials, payments, sensitive personal data, security controls, or an untrusted-input/external-data boundary. Accessibility triggers: a user-facing interface, navigation, form, or interactive control. Missing evidence for a triggered review or an unresolved issue is blocking. This is review evidence only, not a scanner, formal compliance, performance, reliability, or architecture review.

## Scope

Whether the diff stayed within the ticket boundaries.
