"""Every version the published POMs manage is on Maven Central.

A version a BOM or the parent manages reaches every child that names the dependency
without a version; one Central does not have fails that child's build, and a POM on
Central cannot be changed. So a dependency joins a published POM only once its version
is on Central.

Usage: managed-on-central.py <a child's effective POM> <published POM>...
The versions are read from the child's effective POM, where every property is resolved.
"""

import sys
import urllib.error
import urllib.request
import xml.etree.ElementTree as ET

NS = {"m": "http://maven.apache.org/POM/4.0.0"}
CENTRAL = "https://repo1.maven.org/maven2"


def managed(root):
    """(groupId, artifactId, scope, version) of each dependency a POM manages."""
    for d in root.findall("m:dependencyManagement/m:dependencies/m:dependency", NS):
        yield tuple(d.findtext(f"m:{k}", default="", namespaces=NS).strip() for k in ("groupId", "artifactId", "scope", "version"))


def main(effective, published):
    resolved = {(g, a): v for g, a, _, v in managed(ET.parse(effective).getroot())}
    missing = []
    for path in published:
        for g, a, scope, _ in managed(ET.parse(path).getroot()):
            if scope == "import":
                continue  # a BOM: published with these POMs, and checked as one of them
            v = resolved.get((g, a), "")
            url = f"{CENTRAL}/{g.replace('.', '/')}/{a}/{v}/{a}-{v}.pom"
            try:
                urllib.request.urlopen(urllib.request.Request(url, method="HEAD"), timeout=30)
            except urllib.error.HTTPError as e:
                if e.code != 404:
                    raise
                missing.append(f"{path}: {g}:{a}:{v or '(no version)'}")
    for m in missing:
        print(f"not on Maven Central: {m}")
    return 1 if missing else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1], sys.argv[2:]))
