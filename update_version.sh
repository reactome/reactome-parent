#!/usr/bin/env bash

# Input and output XML files
INPUT_FILE="boms/reactome-bom/pom.xml"
OUTPUT_FILE="boms/reactome-bom/pom.xml"

# Check if the file exists
if [[ ! -f "$INPUT_FILE" ]]; then
  echo "Input file '$INPUT_FILE' not found!"
  exit 1
fi

# Process the XML file
while IFS= read -r line; do
  # Match version tags and extract details, allowing for leading spaces
  if [[ $line =~ ^[[:space:]]*\<([^>]+)\>([0-9]+)\.([0-9]+)\.([0-9]+)(-SNAPSHOT)?\<\/.*\>$ ]]; then
    tag="${BASH_REMATCH[1]}"
    major="${BASH_REMATCH[2]}"
    minor="${BASH_REMATCH[3]}"
    patch="${BASH_REMATCH[4]}"
    snapshot="${BASH_REMATCH[5]}"

    # Hardcoded logic for specific packages
    case "$tag" in
      "reactome.reactome-base.version" | \
      "reactome.analysis-core.version" | \
      "reactome.diagram-reader.version" | \
      "reactome.diagram-exporter.version" | \
      "reactome.search-indexer.version" | \
      "reactome.fireworks-exporter.version" | \
      "reactome.reaction-exporter.version" | \
      "reactome.search-core.version" | \
      "reactome.interactor-core.version" | \
      "reactome.sbml-exporter.version" | \
      "reactome.event-pdf.version" | \
      "reactome.reactome-utils.version" | \
      "reactome.analysis-report.version")
        ((minor++))  # Increment minor version
        patch=0      # Reset patch version to zero
        ;;
      "reactome.graph-core.version")
        ((major++))  # Increment major version
        minor=0      # Reset minor version to zero
        patch=0      # Reset patch version to zero
        ;;
    esac

    # Print the updated line, preserving indentation
    leading_spaces=$(echo "$line" | grep -o '^[[:space:]]*') # Extract leading spaces
    echo "${leading_spaces}<$tag>${major}.${minor}.${patch}${snapshot}</$tag>"
  else
    # Print lines that don't match the version pattern
    echo "$line"
  fi
done < "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Updated dependencies written to '$OUTPUT_FILE'."
