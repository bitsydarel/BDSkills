# Policies & Layer Responsibilities

## Non-Negotiable Rules
Strict adherence required during code creation and review:

1.  **UI & State MUST call Use Cases only.** Never call Repositories, Services, or Data Sources directly.
2.  **Use Cases MUST be the only entry point.** Any business intention ("log in", "fetch") must be a Use Case.
3.  **Dependencies MUST flow one-way.** Data Source Impls must never be imported by upper layers.
4.  **Business Objects & Use Cases MUST be framework-agnostic.** No Flutter/UIKit imports.
5.  **DTOs MUST NOT cross architectural boundaries.** They are private to Data Source implementations.
6.  **Repositories/Services MUST return Business Objects.** Never return DTOs.
7.  **Feature modules MUST NOT create cycles.**

## Dependency Matrix

```xml

<dependencyMatrix>
    <layer name="UI &amp; State">
        <imports>
            <importsUI>false</importsUI>
            <importsUseCases>true</importsUseCases>
            <importsRepos>false</importsRepos>
            <importsServices>false</importsServices>
            <importsDataContracts>false</importsDataContracts>
            <importsDataImpl>false</importsDataImpl>
            <importsBusinessObjects>true</importsBusinessObjects>
            <importsDTOs>false</importsDTOs>
        </imports>
    </layer>
    <layer name="Use Cases">
        <imports>
            <importsUI>false</importsUI>
            <importsUseCases>true</importsUseCases>
            <importsRepos>true</importsRepos>
            <importsServices>true</importsServices>
            <importsDataContracts>false</importsDataContracts>
            <importsDataImpl>false</importsDataImpl>
            <importsBusinessObjects>true</importsBusinessObjects>
            <importsDTOs>false</importsDTOs>
        </imports>
        <notes>Composition</notes>
    </layer>
    <layer name="Repos/Services">
        <imports>
            <importsUI>false</importsUI>
            <importsUseCases>false</importsUseCases>
            <importsRepos>false</importsRepos>
            <importsServices>false</importsServices>
            <importsDataContracts>true</importsDataContracts>
            <importsDataImpl>false</importsDataImpl>
            <importsBusinessObjects>true</importsBusinessObjects>
            <importsDTOs>false</importsDTOs>
        </imports>
    </layer>
    <layer name="Data Contracts">
        <imports>
            <importsUI>false</importsUI>
            <importsUseCases>false</importsUseCases>
            <importsRepos>false</importsRepos>
            <importsDataContracts>false</importsDataContracts>
            <importsDataImpl>false</importsDataImpl>
            <importsBusinessObjects>true</importsBusinessObjects>
            <importsDTOs>false</importsDTOs>
        </imports>
    </layer>
    <layer name="Data Impl">
        <imports>
            <importsUI>false</importsUI>
            <importsUseCases>false</importsUseCases>
            <importsRepos>false</importsRepos>
            <importsDataContracts>true</importsDataContracts>
            <importsDataImpl>true</importsDataImpl>
            <importsBusinessObjects>true</importsBusinessObjects>
            <importsDTOs>true</importsDTOs>
        </imports>
    </layer>
</dependencyMatrix>

```

*Note: Data Source Implementations are injected via DI and must never be imported statically by upper layers.*

## Layer Responsibilities

### UI & State
* **MUST**: Call Use Cases for business actions.
* **MUST NOT**: Import Repositories, Data Sources, or DTOs.

### Use Cases
* **MUST**: Represent pure business intentions.
* **Composition**: Allowed only for standalone intentions. Keep shallow (1-2 levels).
* **Prohibited**: Formatting logic or details belonging in UI/Data layers.

### Repositories
* **Role**: Data access boundary (caching, merging).
* **Input**: Data Source Contract.
* **Output**: Business Objects.

### Data Sources
* **Contract**: Interface defining external system interaction (returns Business Objects).
* **Implementation**: Handles external libraries (HTTP, DB) and DTO mapping.