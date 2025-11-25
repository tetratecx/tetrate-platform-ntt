#!/bin/bash

# Setup script for MkDocs documentation structure
# This script automatically discovers demos with artifacts/Readme.md and creates symlinks

echo "Setting up MkDocs documentation..."

# Create docs directory structure
mkdir -p docs/demos
mkdir -p docs/stylesheets
mkdir -p docs/assets

# Remove old symlinks
rm -f docs/demos/*.md

# Discover and create symlinks for all demos
echo ""
echo "Discovering demos in demos/ directory..."
for demo_dir in demos/*/; do
  if [ -d "$demo_dir" ]; then
    demo_name=$(basename "$demo_dir")
    
    # Only check for Readme.md in artifacts subdirectory
    if [ -f "${demo_dir}artifacts/Readme.md" ]; then
      ln -sf "../../${demo_dir}artifacts/Readme.md" "docs/demos/${demo_name}.md"
      echo "✓ Linked ${demo_name} -> ${demo_dir}artifacts/Readme.md"
    else
      echo "✗ Skipped ${demo_name} (no artifacts/Readme.md found)"
    fi
  fi
done

echo ""
echo "✓ MkDocs structure updated successfully!"
echo ""
echo "To update mkdocs.yml navigation, run:"
echo "./generate-nav.sh"