# Reactome Maven Architecture

Reactome packages should all have one of the Reactome Parent as maven arent in order to centralize dependencies and
versions used.

Reactome's developed packages are defined in BOMs under the boms folder.
They are having a parent BOM to simplify their installation and deployment.

```shell
cd boms
mvn clean install # Install bom-parent and reactome-bom
```

reactome-bom manages only versions that are on Maven Central: a library joins it once it is
published there (CI checks every version the published POMs manage). reactome-pwp-bom, whose
GWT libraries are not on Central, is no longer built with them, published or imported by
reactome-parent; reactome-pwp-parent still imports it.

On the other hand, the parents cannot have a common parent so they need to be processed interdependently.

```shell
cd parents/reactome-parent
mvn clean install # Install reactome-parent
mvn clean deploy # Deploy reactome-parent
cd ../reactome-pwp-parent 
mvn clean install # Install reactome-pwp-parent
mvn clean deploy # Deploy reactome-pwp-parent
```

Parents should declare the dependencies version across Reactome code base in order to centralise the declarations of
version for dependencies.

We differentiate pwp from usual reactome as we do not want to have spring-boot-parent as a parent for GWT packages as it might break things.

## Publishing

Pushing a tag `v<reactome-parent's version>` on `main` signs and uploads bom-parent,
reactome-bom and reactome-parent to Maven Central's Central Portal, once a maintainer
approves the `maven-central` environment. The upload arrives as two deployments (the BOMs,
then the parent); publish both, the BOMs first. Nothing is published until someone presses
Publish in the Portal, and nothing published can be changed or removed.

## Strict builds

A child of reactome-parent builds with JDK 17 or newer, and a compiler or javadoc warning
fails its build. A child that cannot be clean yet sets `<reactome.strict>false</reactome.strict>`
in its properties: the warnings are still shown.
