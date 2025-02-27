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

import ballerina/io;
import ballerina/lang.runtime;
import ballerinax/hubspot.crm.extensions.videoconferencing as hsvideoconferencing;

configurable string hapikey = "test-key";
configurable int appId = 12345;
configurable decimal delay = 60.0;

final int:Signed32 appIdSigned32 = check appId.ensureType();

final hsvideoconferencing:ApiKeysConfig apiKeysConfig = {
    hapikey
};
final hsvideoconferencing:Client hubspot = check new (apiKeysConfig);

public function main() returns error? {
    // Scenario 1: A new external video conferencing app is created. Hence the URL details of this new 
    // external video conferencing app should be added to HubSpot App.

    // Step 1: Add the URL details of the new external video conferencing app to HubSpot App.
    hsvideoconferencing:ExternalSettings settings = {
        createMeetingUrl: "https://my-conference.io/create-meeting",
        updateMeetingUrl: "https://my-conference.io/join-meeting",
        deleteMeetingUrl: "https://my-conference.io/record-meeting"
    };
    hsvideoconferencing:ExternalSettings addedSettings = check hubspot->/[appIdSigned32].put(settings);

    // Step 2: Verify whether the URL details of the new external video conferencing app are added to HubSpot App.
    if addedSettings.createMeetingUrl == settings.createMeetingUrl &&
        addedSettings?.updateMeetingUrl == settings?.updateMeetingUrl &&
        addedSettings?.deleteMeetingUrl == settings?.deleteMeetingUrl {
        io:println("Settings updated successfully for scenario 1");
    } else {
        io:println("Error adding settings for scenario 1");
    }

    // Scenario 2: The external video conferencing app changed some of its URL details. Hence the changed 
    // URL details should be updated in HubSpot App.

    // Step 1: Update the URL details of the external video conferencing app in HubSpot App.
    hsvideoconferencing:ExternalSettings newSettings = {
        createMeetingUrl: "https://my-conference.io/meetings/new",
        updateMeetingUrl: "https://my-conference.io/meetings",
        deleteMeetingUrl: "https://my-conference.io/meetings"
    };

    // Step 2: Verify whether the URL details of the external video conferencing app are updated in HubSpot App.
    hsvideoconferencing:ExternalSettings updatedSettings = check hubspot->/[appIdSigned32].put(newSettings);

    if updatedSettings.createMeetingUrl == newSettings.createMeetingUrl &&
        updatedSettings?.updateMeetingUrl == newSettings?.updateMeetingUrl &&
        updatedSettings?.deleteMeetingUrl == newSettings?.deleteMeetingUrl {
        io:println("Settings updated successfully for scenario 2");
    } else {
        io:println("Error updating settings for scenario 2");
    }

    // Scenario 3: The external video conference app now offers an endpoint to verify users. Hence the
    // user verification URL should be added to HubSpot App, while keeping the other details as is.

    // Step 1: Get the current settings of the external video conferencing app from HubSpot App.
    // Note: It takes some time for the settings to be updated in HubSpot CRM. Usually 60 seconds is enough.
    // However, you can increase or decrease the delay as per your need through the Config.toml.
    runtime:sleep(delay);
    hsvideoconferencing:ExternalSettings currentSettings = check hubspot->/[appIdSigned32]();

    // Step 2: Update the user verification URL of the external video conferencing app in HubSpot App.
    hsvideoconferencing:ExternalSettings changedSettings = {
        createMeetingUrl: currentSettings.createMeetingUrl,
        updateMeetingUrl: currentSettings?.updateMeetingUrl,
        deleteMeetingUrl: currentSettings?.deleteMeetingUrl,
        userVerifyUrl: "https://my-conference.io/verify-user"
    };

    // Step 3: Verify whether the user verification URL of the external video conferencing app is updated in HubSpot App.
    hsvideoconferencing:ExternalSettings changedSettingsResponse = check hubspot->/[appIdSigned32].put(changedSettings);

    if changedSettingsResponse.createMeetingUrl == currentSettings.createMeetingUrl &&
        changedSettingsResponse?.updateMeetingUrl == currentSettings?.updateMeetingUrl &&
        changedSettingsResponse?.deleteMeetingUrl == currentSettings?.deleteMeetingUrl &&
        changedSettingsResponse?.userVerifyUrl == changedSettings?.userVerifyUrl {
        io:println("Settings updated successfully for scenario 3");
    } else {
        io:println("Error updating settings for scenario 3");
    }
}
