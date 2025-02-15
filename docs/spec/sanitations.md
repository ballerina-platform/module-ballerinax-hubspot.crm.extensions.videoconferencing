_Author_:  @rtweera\
_Created_: 13.02.2025 \
_Updated_: 14.02.2025 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from HubSpot CRM Video conference.
The OpenAPI specification is obtained from [Hubspot API Reference](https://github.com/HubSpot/HubSpot-public-api-spec-collection/blob/main/PublicApiSpecs/CRM/Video%20Conferencing%20Extension/Rollouts/148903/v3/videoConferencingExtension.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Change the `url` property of the objects in servers array

   - **Original**:
   `https://api.hubspot.com`

   - **Updated**:
   `https://api.hubapi.com/crm/v3/extensions/videoconferencing/settings`

   - **Reason**: This change of adding the common prefix `crm/v3/extensions/videoconferencing/settings` to the base url makes it easier to access the endpoints using the client, also makes the code readable.

2. Update the API `paths`

   - **Original**: Paths included the common prefix above `(i.e. /crm/v3/extensions/videoconferencing/settings)` in each endpoint.
   `/crm/v3/extensions/videoconferencing/settings/{appId}`

   - **Updated**: Common prefix removed from path endpoints.
   `/{appId}`

   - **Reason**: This simplifies the API paths making them shorter and easier to read.

3. Add example for fetchAccountsUri object in External settings for `put` method

   - **Original**: No example was present.

   ```json
   {
      "fetchAccountsUri" : {
         "type" : "string"
      }
   }
   ```

   - **Updated**: Example section added with a sample URI.

   ```json
   {
      "fetchAccountsUri" : {
         "type" : "string",
         "example" : "https://example.xyz/1"
      }
   }
   ```

   - **Reason**: This indicates the proper format of the URI to avoid validation errors.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.json --mode client --license docs/license.txt -o ballerina
```

Note: The license year is hardcoded to 2025, change if necessary.
