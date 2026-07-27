#!/bin/bash
# Lightweight policy fixture for T-002. It verifies the performance review trigger
# exists in canonical workflow sources and self-contained adapter entry points.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "core/roles/developer.md"
  "core/roles/quality.md"
  "templates/AGENTS.md"
  "templates/qa-report-template.md"
  "templates/review-template.md"
  "skills/quality-review/SKILL.md"
  "playbooks/new-feature.md"
  "playbooks/bug-fix.md"
  "adapters/shared/workflow.md"
  "adapters/shared/testing.md"
  "adapters/shared/skill-routing.md"
  "adapters/antigravity/rules/workflow-toolkit.md"
  "adapters/antigravity/workflows/engineering-workflow.md"
  "adapters/cursor/.cursorrules"
  "adapters/cursor/.cursor/rules/workflow.mdc"
  "adapters/cursor/.cursor/rules/testing.mdc"
  "adapters/windsurf/.windsurfrules"
  "adapters/windsurf/.windsurf/rules/workflow.md"
  "adapters/vscode/CLAUDE.md"
  "adapters/vscode/.github/copilot-instructions.md"
  "adapters/devin/AGENTS.md"
  "adapters/devin/.devin/skills/engineering-workflow.md"
  "adapters/claude-code/agents/developer.md"
  "adapters/claude-code/agents/quality.md"
  "adapters/codex/agents/developer.toml"
  "adapters/codex/agents/quality.toml"
  "adapters/grok/agents/developer.md"
  "adapters/grok/agents/quality.md"
  "adapters/opencode/agents/developer.md"
  "adapters/opencode/agents/quality.md"
)

for file in "${required_files[@]}"; do
  path="$ROOT/$file"
  test -f "$path" || { echo "missing required policy file: $file" >&2; exit 1; }
  grep -qi "performance" "$path" || { echo "missing performance trigger: $file" >&2; exit 1; }
  grep -qi "hot path\|database query\|N+1\|response-time\|bundle size\|caching behavior" "$path" || { echo "missing performance trigger details: $file" >&2; exit 1; }
done

for adapter in antigravity claude-code codex cursor devin grok opencode vscode windsurf; do
  cmp -s "$ROOT/adapters/shared/workflow.md" "$ROOT/adapters/$adapter/shared/workflow.md" || {
    echo "derived workflow copy is out of sync: $adapter" >&2; exit 1;
  }
  cmp -s "$ROOT/adapters/shared/testing.md" "$ROOT/adapters/$adapter/shared/testing.md" || {
    echo "derived testing copy is out of sync: $adapter" >&2; exit 1;
  }
  cmp -s "$ROOT/adapters/shared/skill-routing.md" "$ROOT/adapters/$adapter/shared/skill-routing.md" || {
    echo "derived skill-routing copy is out of sync: $adapter" >&2; exit 1;
  }
done

echo "T-002 performance review trigger checks passed."
