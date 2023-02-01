# Reactome Maven Architecture

Reactome packages should all have one of the Reactome Parent as maven arent in order to centralize dependencies and
versions used.

Reactome's developed packages are defined in BOMs under the boms folder.
They are having a parent BOM to simplify their installation and deployment.

```shell
cd boms
mvn clean install # Install reactome-bom and reactome-pwp-bom
mvn clean deploy # Deploy reactome-bom and reactome-pwp-bom
```

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

