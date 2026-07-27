# Engineering Workflow Toolkit

This project uses an engineering workflow with distinct phases. Follow the conventions in `.github/copilot-instructions.md` for all engineering work.

## Quick reference

- **Hard gates**: developer always hands off to quality; quality must produce qa-report.md and review.md; never declare done without quality artifacts.
- **Three-tier routing**: Tier 1 (bounded) → develop. Tier 2 (unclear) → ask questions. Tier 3 (complex) → plan first.
- **Three-level testing**: unit tests, feature tests, end-to-end tests. Bug fixes require regression tests at all applicable levels.
- **Quality phases**: run tests → inspect diff (correctness, security, scope) → write artifacts with blocking/advisory findings.
- **Prototype-first**: approve the first-feature plan once, then build without routine confirmations.
- **Risk-triggered security and accessibility evidence only**: security triggers are authentication, authorization, sessions, secrets/credentials, payments, sensitive personal data, security controls, or an untrusted-input/external-data boundary; accessibility triggers are a user-facing interface, navigation, form, or interactive control. Record the trigger, change-specific checks, results, and remaining risk. Missing triggered evidence or an unresolved issue blocks QA/review; non-triggered changes need no evidence. This is not a scanner, formal compliance, performance, reliability, or architecture review.
