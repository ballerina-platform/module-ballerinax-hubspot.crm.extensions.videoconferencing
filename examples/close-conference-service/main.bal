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
import ballerina/io;
import ballerina/lang.runtime;
import ballerinax/hubspot.crm.extensions.videoconferencing as hsvideoconferencing;

configurable string hapikey = ?;
configurable int appId = ?;

final int:Signed32 appIdSigned32 = <int:Signed32>appId;

final hsvideoconferencing:ApiKeysConfig apiKeysConfig = {
    hapikey: hapikey
};
final hsvideoconferencing:Client hsVideoConferencing = check new (apiKeysConfig);

public function main() returns error? {
    // Scenario 1: The external video conferencing app no longer supports the update meeting endpoint.
    // Hence, the updateMeetingUrl should be removed from HubSpot App.

    // Step 1: Set the current settings of the external video conferencing app in HubSpot App.
    hsvideoconferencing:ExternalSettings settings = {
        createMeetingUrl: "https://my-conference.io/create-meeting",
        updateMeetingUrl: "https://my-conference.io/join-meeting",
        deleteMeetingUrl: "https://my-conference.io/record-meeting"
    };
    any _ = check hsVideoConferencing->/[appIdSigned32].put(settings);

    // Step 2: Get the current settings of the external video conferencing app from HubSpot App.
    runtime:sleep(60); // TODO: Handle differently. Wait for the server to be updated with the settings
    hsvideoconferencing:ExternalSettings|error currentSettings = hsVideoConferencing->/[appIdSigned32]();
    if currentSettings !is hsvideoconferencing:ExternalSettings {
        panic error("Error getting settings");
    }

    // Step 3: Remove the updateMeetingUrl from the settings.
    hsvideoconferencing:ExternalSettings updatedSettings = {
        createMeetingUrl: currentSettings.createMeetingUrl,
        deleteMeetingUrl: currentSettings?.deleteMeetingUrl
    };

    // Step 4: Verify whether the updateMeetingUrl is removed from HubSpot App.
    hsvideoconferencing:ExternalSettings|error updatedSettingsResponse = hsVideoConferencing->/[appIdSigned32].put(updatedSettings);
    if updatedSettingsResponse is hsvideoconferencing:ExternalSettings &&
        updatedSettingsResponse.createMeetingUrl == currentSettings.createMeetingUrl &&
        updatedSettingsResponse?.deleteMeetingUrl == currentSettings?.deleteMeetingUrl &&
        updatedSettingsResponse?.updateMeetingUrl is () {

        io:println("Update meeting URL removed successfully for scenario 1");
    } else {
        io:println("Error removing update meeting URL for scenario 1");
    }

    // Scenario 2: The entire external video conferencing app is brought down. There is no alternative app for now 
    // as well. Hence, all the settings of the external video conferencing app should be deleted from HubSpot App.

    // Step 1: Delete all the settings of the external video conferencing app from HubSpot App.
    http:Response deleteResponse = check hsVideoConferencing->/[appIdSigned32].delete();

    // Step 2: Verify whether all the settings are deleted from HubSpot App.
    if deleteResponse.statusCode == 204 {
        io:println("All settings deleted successfully for scenario 2");
    } else {
        io:println("Error deleting all settings for scenario 2");
    }
}
