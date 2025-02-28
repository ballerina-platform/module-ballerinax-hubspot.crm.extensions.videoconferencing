// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/lang.runtime;
import ballerina/os;
import ballerina/test;

configurable string hapikey = "my-key-123";
configurable int appId = 12345;
configurable decimal delay = 60.0;

configurable string liveServerUrl = "https://api.hubapi.com/crm/v3/extensions/videoconferencing/settings";
configurable string localServerUrl = "http://localhost:9090";
configurable boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";

final int:Signed32 appIdSigned32 = check appId.ensureType();
const int:Signed32 incorrectAppId = 1234;
final Client hubspot = check initClient();

const ExternalSettings partialSettings = {
    createMeetingUrl: "https://example.com/create-meeting"
};
const ExternalSettings completeSettings = {
    createMeetingUrl: "https://example.com/create-meeting",
    updateMeetingUrl: "https://example.com/update-meeting",
    deleteMeetingUrl: "https://example.com/delete-meeting",
    userVerifyUrl: "https://example.com/verify-user",
    fetchAccountsUri: "https://example.com/fetch-accounts"
};

isolated function initClient() returns Client|error {
    if isLiveServer {
        final ApiKeysConfig apiKeysConfig = {
            hapikey
        };
        return check new (apiKeysConfig, {}, liveServerUrl);
    }
    return check new ({
        hapikey
    }, {}, localServerUrl);
}

@test:BeforeSuite
function beforeSuite() returns error? {
    // Clear all previously saved settings (if any) in HubSpot
    http:Response _ = check hubspot->/[appIdSigned32].delete();
}

@test:Config {
    groups: ["negative_tests"]
}
function testGetEmptySettings() returns error? {
    // Note: It takes some time for the settings to be updated in HubSpot CRM. Usually 60 seconds is enough.
    // However, you can increase or decrease the delay as per your need through the Config.toml.
    if isLiveServer {
        runtime:sleep(delay);
    }
    ExternalSettings|error settings = hubspot->/[appIdSigned32]();
    test:assertTrue(settings is http:ClientRequestError, "Error getting settings");
}

@test:Config {
    dependsOn: [testGetEmptySettings],
    groups: ["positive_tests"]
}
function testPartialPutSettings() returns error? {
    ExternalSettings settings = check hubspot->/[appIdSigned32].put(partialSettings);
    test:assertEquals(settings.createMeetingUrl, partialSettings.createMeetingUrl, "Error putting settings");
}

@test:Config {
    dependsOn: [testPartialPutSettings],
    groups: ["negative_tests"]
}
function testPutIncorrectAppId() returns error? {
    ExternalSettings|error settings = hubspot->/[incorrectAppId].put(partialSettings);
    test:assertTrue(settings is http:ClientRequestError, "Error putting settings with incorrect appId");
}

@test:Config {
    dependsOn: [testPartialPutSettings],
    groups: ["positive_tests"]
}
function testGetSettings() returns error? {
    // Note: It takes some time for the settings to be updated in HubSpot CRM. Usually 60 seconds is enough.
    // However, you can increase or decrease the delay as per your need through the Config.toml.
    if isLiveServer {
        runtime:sleep(delay);
    }
    ExternalSettings|http:Response settings = check hubspot->/[appIdSigned32]();
    test:assertTrue(settings is ExternalSettings, "Type mismatch");
    if settings is ExternalSettings {
        test:assertEquals(settings.createMeetingUrl, partialSettings.createMeetingUrl, "Error getting settings");
    }
}

@test:Config {
    dependsOn: [testPartialPutSettings],
    groups: ["negative_tests"]
}
function testGetIncorrectAppId() returns error? {
    ExternalSettings|error settings = hubspot->/[incorrectAppId]();
    test:assertTrue(settings is http:ClientRequestError, "Error getting settings with incorrect appId");
}

@test:Config {
    dependsOn: [testGetSettings],
    groups: ["negative_tests"]
}
function testDeleteIncorrectAppId() returns error? {
    http:Response response = check hubspot->/[incorrectAppId].delete();
    test:assertEquals(response.statusCode, 404, "Error deleting settings with incorrect appId");
}

@test:Config {
    dependsOn: [testPartialPutSettings],
    groups: ["positive_tests"]
}
function testPutCompleteSettings() returns error? {
    ExternalSettings settings = check hubspot->/[appIdSigned32].put(completeSettings);
    test:assertEquals(settings, completeSettings, "Error putting complete settings");
}

@test:Config {
    dependsOn: [testGetSettings],
    groups: ["positive_tests"]
}
function testDeleteCompleteSettings() returns error? {
    http:Response response = check hubspot->/[appIdSigned32].delete();
    test:assertEquals(response.statusCode, 204, "Error deleting settings");
}

@test:AfterSuite
function afterSuite() returns error? {
    // Clear all saved test settings in HubSpot
    http:Response _ = check hubspot->/[appIdSigned32].delete();
}
