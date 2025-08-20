# Shared Artefact Library

Contains artefacts (resource models) which are shared among deployments and modules.

Archetypes generally speaking are JSON documents, closely based on the API schema. E.g. ARM or MS-Graph instances.

All of them must have an additional property `definitionName` which is used for references.