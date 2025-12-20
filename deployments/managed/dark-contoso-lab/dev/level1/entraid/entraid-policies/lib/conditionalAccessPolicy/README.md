# Conditional Access Policy Artefacts

Contains additional Conditional Access policies that are going to be deployed for this particular unit, in addition to the ones created my the shared ECP library.

## Artefact format

*File name* must match **.microsoft.graph.conditionalAccessPolicy.json*

To exclude an ECP library artefact from the deployment, add a file named **.microsoft.graph.conditionalAccessPolicy.exclude.json* with only the artefactName of the ECP library policy as property.

caPolicy artefacts are fully based on the [`conditionalAccessPolicy`](https://learn.microsoft.com/en-us/graph/api/resources/conditionalaccesspolicy?view=graph-rest-1.0). MS Graph resource type. However, they require respectively support the following additions:

- `artefactName`: REQUIRED: Unique name which may be used when referencing the particular artefact in downstream modules.

- `object lookup`: OPTIONAL: Instead of static providing GUIDs, the deployment supports the following lookup patterns for the ca polcicy's `conditions` objects:
  - `<ECP_ARTEFACT>:{artefact name}` - name of a suitable ECP library artefact (e.g. namedLocation)
  - `<DISPLAYNAME>:{object display name}` - displayName of an already existing resource like user, group, service principal (cloud app)
  - `<MAIL>:{email address}` - email address of an already existing user or group.
  - `<USERPRINCIPALNAME>:{account upn}` - up of an already existing user
  Using those, `applications`, `clientApplications`, `locations` and `users` can be made dynamic.





## Example

``` JSON
{
    "artefactName": "example-minimal",
    "displayName": "999 - EXAMPLE: Minimal Conditional Access Policy",
    "state": "enabledForReportingButNotEnforced",
    "sessionControls": null,
    "conditions": {
        "userRiskLevels": [],
        "signInRiskLevels": [],
        "clientAppTypes": [
            "all"
        ],
        "servicePrincipalRiskLevels": [],
        "insiderRiskLevels": null,
        "platforms": null,
        "devices": null,
        "clientApplications": null,
        "authenticationFlows": null,
        "applications": {
            "includeApplications": [
                "All"
            ],
            "excludeApplications": [],
            "includeUserActions": [],
            "includeAuthenticationContextClassReferences": [],
            "applicationFilter": null
        },
        "users": {
            "includeUsers": [
                "All"
            ],
            "excludeUsers": [
                "<USERPRINCIPALNAME>:breakglass@abcdefg.onmicrosoft.com"
            ],
            "includeGroups": [],
            "excludeGroups": [
                "<DISPLAYNAME>:Example Entra Id group"
            ],
            "includeRoles": [],
            "excludeRoles": [],
            "includeGuestsOrExternalUsers": null,
            "excludeGuestsOrExternalUsers": null
        },
        "locations": {
            "includeLocations": [
                "<ECP_ARTEFACT>:Country-Critical-High",
                "<ECP_ARTEFACT>:Country-Critical-Medium",
                "<ECP_ARTEFACT>:Country-Critical-Elevated"
            ],
            "excludeLocations": []
        }
    },
    "grantControls": {
        "operator": "OR",
        "builtInControls": [
            "block"
        ],
        "customAuthenticationFactors": [],
        "termsOfUse": [],
        "authenticationStrength": null
    }
}

```
