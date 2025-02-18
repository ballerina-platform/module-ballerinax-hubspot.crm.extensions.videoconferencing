import ballerina/http;
import ballerina/test;

configurable string hapikey = ?;
configurable int appId = ?;

configurable string liveServerUrl = "https://api.hubapi.com/crm/v3/extensions/videoconferencing/settings";
configurable string localServerUrl = "http://localhost:9090";
configurable boolean isLiveServer = true;

final int:Signed32 appIdSigned32 = <int:Signed32> appId;
final string serviceUrl = isLiveServer ? liveServerUrl : localServerUrl;
final Client hubSpotVideoConferrencing = check initClient();

isolated function initClient() returns Client|error {
    if isLiveServer {
        final ApiKeysConfig apiKeysConfig = {
            hapikey: hapikey
        };
        return check new (apiKeysConfig, {}, serviceUrl);
    }
    return check new ({
        hapikey: hapikey
    }, {}, serviceUrl);
}

@test:Config {
    enable: true
} 
function testDeleteSettings() returns error? {
    http:Response response = check hubSpotVideoConferrencing->/[appIdSigned32].delete();
    test:assertTrue(response.statusCode == 204, "Error deleting settings");
}

@test:Config {
    enable: true,
    dependsOn: [testDeleteSettings]
}
function testGetEmptySettings() returns error? {
    ExternalSettings|http:ClientRequestError|error settings = hubSpotVideoConferrencing->/[appIdSigned32]();
    // TODO: Is there a better way to check for a 404 error rather than checking for all 4xx errors?
    test:assertTrue(settings is http:ClientRequestError, "Error getting settings");
}

@test:Config {
    enable: true,
    dependsOn: [testDeleteSettings]
}
function testPutSettings() returns error? {
    ExternalSettings payload = {
        createMeetingUrl: "https://example.com/create-meeting"
    };
    ExternalSettings settings = check hubSpotVideoConferrencing->/[appIdSigned32].put(payload);
    test:assertEquals(settings.createMeetingUrl, "https://example.com/create-meeting", "Error putting settings");
}

@test:Config {
    enable: true,
    dependsOn: [testPutSettings]
}
function testGetSettings() returns error? {
    ExternalSettings|http:Response settings = check hubSpotVideoConferrencing->/[appIdSigned32]();
    test:assertTrue(settings is ExternalSettings, "Type mismatch");
    if (settings is ExternalSettings) {
        test:assertEquals(settings.createMeetingUrl, "https://example.com/create-meeting", "Error getting settings");
    }
}

@test:Config {
    enable: true,
    dependsOn: [testGetSettings]
}
function testDeleteSettingsAgain() returns error? {
    http:Response response = check hubSpotVideoConferrencing->/[appIdSigned32].delete();
    test:assertTrue(response.statusCode == 204, "Error deleting settings");
}



