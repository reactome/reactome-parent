#!/usr/bin/env bash

POM_FILE="boms/reactome-bom/pom.xml"

if [ -z "${VERSIONS_FILE_PATH}" ]; then
    echo "Error: Please define \${VERSIONS_FILE_PATH} in the GO-CD environment or in the server."
    exit 1
fi

# Function to update minor version and reset patch version
update_minor_version() {
    local version="$1"
    local major minor patch
    IFS='.' read -r major minor patch <<< "$version"
    echo "$major.$((minor + 1)).0"
}

# Function to update major version and reset others to 0
update_major_version() {
    local version="$1"
    local major minor patch
    IFS='.' read -r major minor patch <<< "$version"
    echo "$((major + 1)).0.0"
}

# Extract current versions from pom.xml
get_current_version() {
    local key="$1"
    xmlstarlet sel -N _="http://maven.apache.org/POM/4.0.0" -t -v "//_:${key}" "${POM_FILE}"
}

# Function to update versions file
update_versions_file() {
    local package_name="$1"
    local new_version="$2"
    if grep -q "^${package_name}=" "${VERSIONS_FILE_PATH}"; then
      if [[ "$(uname)" == "Darwin" ]]; then
          sed -i '' "s/^${package_name}=.*/${package_name}=${new_version}/" "${VERSIONS_FILE_PATH}"
      else
          sed -i "s/^${package_name}=.*/${package_name}=${new_version}/" "${VERSIONS_FILE_PATH}"
      fi
    else
        echo "${package_name}=${new_version}" >> "${VERSIONS_FILE_PATH}"
    fi
}

# Define updated versions and update versions file
update_and_store_version() {
    local key="$1"
    local package_name="$2"
    local new_version
    if [[ "$key" == "reactome.graph-core.version" ]]; then
        new_version=$(update_major_version "$(get_current_version "$key")")
    else
        new_version=$(update_minor_version "$(get_current_version "$key")")
    fi
    update_versions_file "$package_name" "$new_version"
    echo "$new_version"
}

SEARCH_INDEXER_VERSION=$(update_and_store_version "reactome.search-indexer.version" "SEARCH_INDEXER_VERSION")
SBML_EXPORTER_VERSION=$(update_and_store_version "reactome.sbml-exporter.version" "SBML_EXPORTER_VERSION")
ANALYSIS_CORE_VERSION=$(update_and_store_version "reactome.analysis-core.version" "ANALYSIS_CORE_VERSION")
GRAPH_CORE_VERSION=$(update_and_store_version "reactome.graph-core.version" "GRAPH_CORE_VERSION")
DIAGRAM_READER_VERSION=$(update_and_store_version "reactome.diagram-reader.version" "DIAGRAM_READER_VERSION")
DIAGRAM_EXPORTER_VERSION=$(update_and_store_version "reactome.diagram-exporter.version" "DIAGRAM_EXPORTER_VERSION")
EVENT_PDF_VERSION=$(update_and_store_version "reactome.event-pdf.version" "EVENT_PDF_VERSION")
GRAPH_IMPORTER_VERSION=$(update_and_store_version "reactome.graph-importer.version" "GRAPH_IMPORTER_VERSION")
DIAGRAM_CONVERTER_VERSION=$(update_and_store_version "reactome.diagram-converter.version" "DIAGRAM_CONVERTER_VERSION")
FIREWORKS_LAYOUT_VERSION=$(update_and_store_version "reactome.fireworks-layout.version" "FIREWORKS_LAYOUT_VERSION")
DATA_EXPORT_VERSION=$(update_and_store_version "reactome.data-export.version" "DATA_EXPORT_VERSION")
INTERACTION_EXPORTER_VERSION=$(update_and_store_version "reactome.interaction-exporter.version" "INTERACTION_EXPORTER_VERSION")
GRAPH_QA_VERSION=$(update_and_store_version "reactome.graph-qa.version" "GRAPH_QA_VERSION")
REACTION_EXPORTER_VERSION=$(update_and_store_version "reactome.reaction-exporter.version" "REACTION_EXPORTER_VERSION")
SEARCH_CORE_VERSION=$(update_and_store_version "reactome.search-core.version" "SEARCH_CORE_VERSION")
INTERACTORS_CORE_VERSION=$(update_and_store_version "reactome.interactors-core.version" "INTERACTORS_CORE_VERSION")
ANALYSIS_REPORT_VERSION=$(update_and_store_version "reactome.analysis-report.version" "ANALYSIS_REPORT_VERSION")
SERVER_JAVA_UTILS_VERSION=$(update_and_store_version "reactome.reactome-utils.version" "SERVER_JAVA_UTILS_VERSION")

# Use xmlstarlet to update the versions in pom.xml
xmlstarlet ed -L \
    -u "//_:reactome.search-indexer.version" -v "${SEARCH_INDEXER_VERSION}" \
    -u "//_:reactome.sbml-exporter.version" -v "${SBML_EXPORTER_VERSION}" \
    -u "//_:reactome.analysis-core.version" -v "${ANALYSIS_CORE_VERSION}" \
    -u "//_:reactome.graph-core.version" -v "${GRAPH_CORE_VERSION}" \
    -u "//_:reactome.diagram-reader.version" -v "${DIAGRAM_READER_VERSION}" \
    -u "//_:reactome.diagram-exporter.version" -v "${DIAGRAM_EXPORTER_VERSION}" \
    -u "//_:reactome.event-pdf.version" -v "${EVENT_PDF_VERSION}" \
    -u "//_:reactome.graph-importer.version" -v "${GRAPH_IMPORTER_VERSION}" \
    -u "//_:reactome.diagram-converter.version" -v "${DIAGRAM_CONVERTER_VERSION}" \
    -u "//_:reactome.fireworks-layout.version" -v "${FIREWORKS_LAYOUT_VERSION}" \
    -u "//_:reactome.data-export.version" -v "${DATA_EXPORT_VERSION}" \
    -u "//_:reactome.interaction-exporter.version" -v "${INTERACTION_EXPORTER_VERSION}" \
    -u "//_:reactome.graph-qa.version" -v "${GRAPH_QA_VERSION}" \
    -u "//_:reactome.reaction-exporter.version" -v "${REACTION_EXPORTER_VERSION}" \
    -u "//_:reactome.search-core.version" -v "${SEARCH_CORE_VERSION}" \
    -u "//_:reactome.interactors-core.version" -v "${INTERACTORS_CORE_VERSION}" \
    -u "//_:reactome.analysis-report.version" -v "${ANALYSIS_REPORT_VERSION}" \
    -u "//_:reactome.reactome-utils.version" -v "${SERVER_JAVA_UTILS_VERSION}" \
    "${POM_FILE}"

echo "Specified versions updated successfully in ${POM_FILE} and recorded in ${VERSIONS_FILE_PATH}."
