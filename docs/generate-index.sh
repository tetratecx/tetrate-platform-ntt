#!/bin/bash

# Generate index.md based on discovered demos

echo "Generating docs/index.md..."

cat > docs/index.md << 'HEADER'
# Tetrate Platform NTT Demos

Welcome to the Tetrate Platform demonstration documentation.

## Available Demos

This documentation covers the following demonstration scenarios:

HEADER

# Iterate through demo directories and add to index
for demo_dir in demos/*/; do
  if [ -d "$demo_dir" ]; then
    demo_name=$(basename "$demo_dir")
    
    # Only include demos that have artifacts/Readme.md
    if [ -f "${demo_dir}artifacts/Readme.md" ]; then
      # Convert directory name to title case with spaces
      # e.g., "app-resilience" -> "App Resilience"
      demo_title=$(echo "$demo_name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2));}1')
      
      echo "- **[${demo_title}](demos/${demo_name}.md)**" >> docs/index.md
    fi
  fi
done

cat >> docs/index.md << 'FOOTER'

Navigate through the menu in the left sidebar to explore each demonstration area.
FOOTER

echo "✓ docs/index.md generated successfully!"