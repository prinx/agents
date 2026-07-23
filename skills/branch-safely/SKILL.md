---
name: branch-safely
description: Use before implementation when checking repository state, selecting a branch, or protecting uncommitted work.
---

# Branch Safely

Before modifying code, check whether the project is a Git repository.

For an existing repository, inspect project conventions, `git status`, and the current branch. Never discard, reset, or overwrite unrelated work. Never work directly on `main` or `master`; create a task feature branch before implementation. Report the branch and pre-existing changes.

For a directory that is not a Git repository, have the orchestrator ask the human whether to initialize it. Explain that Git enables rollback and feature branches. If the human is unsure or requests the default, initialize with `git init -b main`. Do not set global Git identity. Before an initial baseline commit, check local Git identity and ask the human to configure it if absent. Do not create a commit automatically: an initial baseline commit requires an explicit human request. A newly initialized repository can remain on `main` until that requested baseline commit; after that, create a task feature branch before implementation.
