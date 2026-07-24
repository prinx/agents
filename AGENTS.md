# Toolkit Conventions

- Keep portable workflow behavior in `core/`; adapters are hand-maintained tool wrappers, not automatic translation.
- Keep adapters, skills, playbooks, templates, and durable workflow policy under version control.
- Do not commit transient installed workflow state or failure logs.
- Do not pin a model or provider in toolkit adapters.
- Keep risk-based permission rules aligned across core roles, adapters, skills, and installation paths. Never weaken protected-file approval or secret redaction rules.
- Known local build, test, and dev commands are allowed by default. Package installation, publishing, destructive, remote, and secret-related commands ask first.
