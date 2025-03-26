#!/usr/bin/env bash

xmlstarlet ed -L \
-u "//_:reactome.graph-core.version" -v "${GRAPH_CORE_VERSION}" \
-u "//_:reactome.sbml-exporter.version" -v "${SBML_EXPORTER_VERSION}" \
-u "//_:reactome.search-indexer.version" -v "${SEARCH_INDEXER_VERSION}" \
-u "//_:reactome.analysis-core.version" -v "${ANALYSIS_CORE_VERSION}" \
-u "//_:reactome.graph-core.version" -v "${GRAPH_CORE_VERSION}" \
-u "//_:reactome.diagram-exporter.version" -v "${DIAGRAM_EXPORTER_VERSION}" \
-u "//_:reactome.event-pdf.version" -v "${EVENT_PDF_VERSION}" \
-u "//_:reactome.graph-importer.version" -v "${GRAPH_IMPORTER_VERSION}" \
-u "//_:reactome.diagram-converter.version" -v "${DIAGRAM_CONVERTER_VERSION}" \
-u "//_:reactome.fireworks-layout.version" -v "${FIREWORKS_LAYOUT_VERSION}" \
-u "//_:reactome.data-export.version" -v "${DATA_EXPORT_VERSION}" \
-u "//_:reactome.interaction-exporter.version" -v "${INTERACTION_EXPORTER_VERSION}" \
-u "//_:reactome.graph-qa.version" -v "${GRAPH_QA_VERSION}" \
-u "//_:reactome.diagram-reader.version" -v "${DIAGRAM_READER_VERSION}" \
-u "//_:reactome.reaction-exporter.version" -v "${REACTION_EXPORTER_VERSION}" \
-u "//_:reactome.search-core.version" -v "${SEARCH_CORE_VERSION}" \
-u "//_:reactome.interactors-core.version" -v "${INTERACTORS_CORE_VERSION}" \
-u "//_:reactome.analysis-report.version" -v "${ANALYSIS_REPORT_VERSION}" \
-u "//_:reactome.server-java-utils.version" -v "${SERVER_JAVA_UTILS_VERSION}" \
pom.xml
 
