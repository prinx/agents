#!/bin/bash
# Copy shared rules to all adapters
# Run this script whenever the shared rules are updated

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_DIR="$SCRIPT_DIR/shared"
ADAPTERS_DIR="$SCRIPT_DIR"

echo "Copying shared rules to adapters..."

# For each adapter, copy the shared rules
for adapter_dir in "$ADAPTERS_DIR"/*/; do
    adapter_name=$(basename "$adapter_dir")
    
    # Skip the shared directory itself
    if [ "$adapter_name" = "shared" ]; then
        continue
    fi
    
    echo "  Updating $adapter_name..."
    
    # Copy shared rules to a temporary location
    mkdir -p "$adapter_dir/shared"
    cp "$SHARED_DIR"/*.md "$adapter_dir/shared/"
done

echo "Done. Shared rules copied to all adapters."
echo ""
echo "Note: Adapter-specific orchestrator files still need to include these shared rules."
echo "The shared rules are reference copies — update the adapter orchestrators to include them."
