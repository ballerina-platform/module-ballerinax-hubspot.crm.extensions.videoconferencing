# [Save settings for a video conferencing service](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/tree/main/examples/operate-conference-service/)

This example demonstrates how to use the `HubSpot CRM Video conference connector` to create and manage settings related to an external video conferencing service. This covers the create and update of settings for notifying the external video conferencing service about meetings scheduled in the HubSpot CRM by users. This allows the external video conferencing application to adjust the scheduled video conferences automatically when the meeting details (scheduled time, date etc.) change in the HubSpot CRM.  

## Prerequisites

1. Ballerina Swan Lake Update 11 (2201.11.0).

2. HubSpot developer account: Create a HubSpot developer account and create an app to obtain the necessary credentials. Refer to the [Setup Guide](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/tree/main/ballerina/README.md) for instructions.

3. `Config.toml`: Add the `Config.toml` in the example's root directory and add the obtained credentials from HubSpot. Here's an example of how your `Config.toml` file should look:

    ```toml
    hapikey = <HubSpot developer API key>  # string
    appId = <App ID>  # int
    ```

## Running an example

Execute the following commands to build an example from the source:

- To build an example:

  ```bash
  bal build
  ```

- To run an example:

  ```bash
  bal run
  ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

- To build all the examples:

  ```bash
  ./build.sh build
  ```
  
- To run all the examples:

  ```bash
  ./build.sh run
  ```
