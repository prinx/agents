---
name: solution-design
description: Use when translating approved requirements into a solution design, architecture fit, risks, and test strategy.
---

# Solution Design

Prefer the smallest design consistent with the approved first feature and existing architecture. Propose a simple stack and lightweight implementation plan only for that feature, with necessary interfaces, data implications, risks, tradeoffs, and proportionate test strategy in `plan.md`. The test strategy must specify which test levels apply (unit, feature, end-to-end), what each covers, and how the developer will verify them. For a bug fix, the plan must include regression tests at all applicable levels before the fix. Keep future ideas short and non-binding. Do not add infrastructure, services, abstractions, or modules unless required. Escalate unresolved irreversible, security, cost, privacy, or credential decisions.
