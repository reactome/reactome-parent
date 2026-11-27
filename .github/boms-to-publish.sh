#!/usr/bin/env bash
# Which of the BOMs' modules a release publishes: those whose version is not on Maven
# Central yet. Central refuses a version it already has, so a release that changes only
# reactome-parent publishes neither BOM, and one that changes only reactome-bom publishes
# it alone. Prints a value for `mvn -pl` ("." is bom-parent), or nothing.
#
# Usage: boms-to-publish.sh   (from the repository's root; CENTRAL overrides the address)
set -euo pipefail
central="${CENTRAL:-https://repo1.maven.org/maven2}"

version() {
    mvn -B -ntp -q help:evaluate -Dexpression=project.version -DforceStdout -N -f "$1"
}
on_central() {
    local code
    code=$(curl -s -o /dev/null -w '%{http_code}' -m 30 "$central/org/reactome/maven/$1/$2/$1-$2.pom")
    case "$code" in
        200) return 0 ;;
        404) return 1 ;;
        *) echo "Central answered $code for $1 $2" >&2; exit 2 ;;
    esac
}

modules=()
on_central bom-parent "$(version boms/pom.xml)" || modules+=(.)
on_central reactome-bom "$(version boms/reactome-bom/pom.xml)" || modules+=(reactome-bom)
(IFS=,; echo "${modules[*]}")
