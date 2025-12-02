#!/bin/bash

# Setup script for MkDocs documentation structure
# This script automatically discovers demos with artifacts/Readme.md and creates symlinks

echo "Setting up MkDocs documentation..."

# Create docs directory structure
mkdir -p docs/demos
mkdir -p docs/stylesheets
mkdir -p docs/assets
mkdir -p docs/images

# Remove old symlinks and copied files
rm -f docs/demos/*.md
rm -rf docs/images/*

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
      
      # Copy any image files from artifacts directory
      image_count=0
      for ext in png jpg jpeg gif svg; do
        for img in "${demo_dir}artifacts/"*."$ext"; do
          if [ -f "$img" ]; then
            mkdir -p "docs/images/${demo_name}"
            cp "$img" "docs/images/${demo_name}/"
            ((image_count++))
          fi
        done
      done
      
      if [ $image_count -gt 0 ]; then
        echo "  ↳ Copied $image_count image(s) for ${demo_name}"
      fi
    else
      echo "✗ Skipped ${demo_name} (no artifacts/Readme.md found)"
    fi
  fi
done

echo ""
echo "✓ MkDocs structure updated successfully!"
echo ""

# Generate index.md automatically
if [ -f "docs/generate-index.sh" ]; then
  echo "Generating index.md..."
  docs/generate-index.sh
fi

echo "Note: Update image paths in your Readme.md files to use:"
echo "../images/demo-name/image.png"