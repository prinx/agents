# Toolkit Conventions

- Keep portable workflow behavior in `core/`; adapters are hand-maintained tool wrappers, not automatic translation.
- Keep adapters, skills, playbooks, templates, and durable workflow policy under version control.
- Do not commit transient installed workflow state or failure logs.
- Do not pin a model or provider in toolkit adapters.
