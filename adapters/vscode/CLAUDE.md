# Engineering Workflow Toolkit

This project uses an engineering workflow with distinct phases. Follow the conventions in `.github/copilot-instructions.md` for all engineering work.

## Quick reference

- **Hard gates**: developer always hands off to quality; quality must produce qa-report.md and review.md; never declare done without quality artifacts.
- **Three-tier routing**: Tier 1 (bounded) → develop. Tier 2 (unclear) → ask questions. Tier 3 (complex) → plan first.
- **Three-level testing**: unit tests, feature tests, end-to-end tests. Bug fixes require regression tests at all applicable levels.
- **Quality phases**: run tests → inspect diff (correctness, security, scope) → write artifacts with blocking/advisory findings.
- **Prototype-first**: approve the first-feature plan once, then build without routine confirmations.
