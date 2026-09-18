# Conditional Named Location Artefacts

Contains additional Conditional Access Named Locations that are going to be deployed for this particular unit, in addition to the ones created my the shared ECP library.

## Artefact format

*File name* must match **.microsoft.graph.{country|ip}NamedLocation.json*

To exclude an ECP library artefact from the deployment, add a file named **.microsoft.graph.{country|ip}NamedLocation.exclude.json* with only the artefactName of the ECP library policy as property.

caPolicy artefacts are fully based on the [`namedLocation`](https://learn.microsoft.com/en-us/graph/api/resources/namedlocation?view=graph-rest-1.0). MS Graph resource type. However, they require respectively support the following additions:

- `artefactName`: REQUIRED: Unique name which may be used when referencing the particular artefact in downstream modules.

## Example

``` JSON
{
    "artefactName": "IP-EXAMPLE",
    "displayName": "IPs: Example Trusted Location",
    "isTrusted": true,
    "ipRanges": [
        {
            "cidrAddress": "198.51.100.0/24"
        }
    ]
}

```
