# Ballerina HubSpot CRM Video conference connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/actions/workflows/trivy-scan.yml)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/actions/workflows/build-with-bal-test-graalvm.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/actions/workflows/build-with-bal-test-graalvm.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/hubspot.crm.extensions.videoconferencing.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%hubspot.crm.extensions.videoconferencing)

## Overview

[HubSpot](https://developers.hubspot.com) is an AI-powered customer relationship management (CRM) platform.

The `hubspot.crm.extensions.videoconferencing` offers APIs to connect and interact with the [HubSpot Video conferencing extension's API](https://developers.hubspot.com/docs/reference/api/crm/extensions/video-conferencing) endpoints, specifically based on the [HubSpot REST API](https://developers.hubspot.com/docs/reference/api).

## Setup guide

To use the `HubSpot CRM Video conference connector`, you need a HubSpot developer account and an associated app with API access. If you don’t have one, register for a HubSpot developer account first.

### Step 1: Login to a HubSpot developer account

If you don't have a HubSpot developer account, you can sign up to a free account [here](https://developers.hubspot.com/get-started)

If you have an account already, go to the [HubSpot developer portal](https://app.hubspot.com/)

### Step 2 (Optional): Create a developer test account

Within app developer accounts, you can create [developer test accounts](https://developers.hubspot.com/docs/getting-started/account-types#developer-test-accounts) to test apps and integrations without affecting any real HubSpot data.

> **Note: These accounts are only for development and testing purposes. In production you should not use developer test accounts.**

1. Go to `Test accounts` section from the left sidebar.
   ![Test accounts section](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/main/docs/resources/test-accounts-section.png)

2. Click `Create developer test account`.
   ![Create developer test account](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/main/docs/resources/create-dev-account.png)

3. In the dialogue box, give a name to your test account and click `Create`.
   ![Name the developer test account](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/main/docs/resources/name-dev-account.png)

### Step 3: Create a HubSpot app

1. In your developer account, navigate to the `Apps` section. Click on `Create app`
   ![Create app](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/main/docs/resources/create-app.png)

2. Provide the required app name and optionally a description.
   ![Name the app](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/main/docs/resources/name-app.png)

### Step 4: Set redirect URI

1. Move to the `Auth` tab.
   ![Move to auth tab](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/main/docs/resources/auth-tab.png)

2. Add your `Redirect URL` in the relevant section. You can also use localhost addresses for local development purposes. Click `Create app`.
   ![Add redirect URL](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/main/docs/resources/set-redirect-url.png)

### Step 5: Get your app ID

1. Navigate to the `Apps` section, again.
  ![Go to Apps](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/main/docs/resources/go-to-apps.png)

2. Obtain the `App ID`.
  ![Get app ID](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/main/docs/resources/get-app-id.png)

### Step 6: Get your developer API key

1. Click on `Keys` section on the left sidebar and then on `Developer API Key`.
  ![Go to developer API key](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/main/docs/resources/dev-key-screen.png)

2. Click on `Create Key`.
  ![Create the key](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/main/docs/resources/create-dev-key.png)

3. Click on `Show`.
  ![Show the key](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/main/docs/resources/show-dev-key.png)

4. Click on `Copy` to obtain the developer API key.
  ![Copy the key](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/main/docs/resources/copy-dev-key.png)

>**Store the App ID (obtained in Step 4) and Developer API Key (Obtained in Step 5) securely for use in your application.**

## Quickstart

To use the `HubSpot CRM Video conference connector` in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `hubspot.crm.extensions.videoconferencing` module.

```ballerina
import ballerinax/hubspot.crm.extensions.videoconferencing as hsvideoconferencing;
```

### Step 2: Instantiate a new connector

1. Add these configurable and final variables in your `.bal` file.

   ```ballerina
   configurable string hapikey = ?;
   configurable int appId = ?;

   final int:Signed32 appIdSigned32 = check appId.ensureType();
   ```

2. Instantiate a `hsvideoconferencing:ApiKeysConfig` with the defined `hapikey` and initialize the connector with it.

   ```ballerina
   final hsvideoconferencing:ApiKeysConfig apiKeysConfig = {
      hapikey
   };

   final hsvideoconferencing:Client hubspot = check new (apiKeysConfig);
   ```

3. Create a `Config.toml` file and, configure the obtained credentials in the above steps as follows:

   ```toml
    hapikey = <Hubspot developer API key>  # string
    appId = <App ID>  # int
   ```

### Step 3: Invoke the connector operation

Utilize the available connector operations. A sample use case is shown below.

#### Create or update meeting settings

```ballerina
public function main() returns error? {
   hsvideoconferencing:ExternalSettings settings = {
      createMeetingUrl: "https://example.com/create-meeting",
      updateMeetingUrl: "https://example.com/update-meeting",
      deleteMeetingUrl: "https://example.com/delete-meeting",
      userVerifyUrl: "https://example.com/verify-user",
      fetchAccountsUri: "https://example.com/fetch-accounts"
   };

   hsvideoconferencing:ExternalSettings response = check hubspot->/[appIdSigned32].put(settings);
}
```

#### Run the Ballerina application

```bash
bal run
```

## Examples

The `HubSpot CRM Video conference connector` provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/tree/main/examples/), covering the following use cases:

1. [Save settings for a video conferencing service](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/tree/main/examples/operate-conference-service/) - This example demonstrates how to save settings in HubSpot CRM for a video conferencing service using the connector.
2. [Remove saved settings for a video conferencing service](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.extensions.videoconferencing/tree/main/examples/close-conference-service/) - This example demonstrates how to remove the saved settings in HubSpot CRM for an external video conferencing application using the connector.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`hubspot.crm.extensions.videoconferencing` package](https://central.ballerina.io/ballerinax/hubspot.crm.extensions.videoconferencing/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
