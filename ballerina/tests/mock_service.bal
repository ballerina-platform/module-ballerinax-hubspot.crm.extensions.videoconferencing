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

ExternalSettings meetingSettings = {
    createMeetingUrl: ""
};

service on new http:Listener(9090) {
    resource function get [int:Signed32 appId]() returns ExternalSettings|error {
        if appId == appIdSigned32 && meetingSettings.createMeetingUrl != "" {
            return meetingSettings;
        } else {
            return <http:ClientRequestError>error("Invalid appId or empty meeting settings", body = "", headers = {}, statusCode = 404);
        }
    }

    resource function put [int:Signed32 appId](@http:Payload ExternalSettings payload) returns ExternalSettings|error {
        if appId != appIdSigned32 {
            return <http:ClientRequestError>error("Invalid appId", body = "", headers = {}, statusCode = 400);
        }
        meetingSettings = payload;
        return meetingSettings;
    }

    resource function delete [int:Signed32 appId]() returns http:Response|error {
        if appId != appIdSigned32 {
            http:Response response = new ();
            response.statusCode = 404;
            response.server = "ballerina";
            return response;
        }
        meetingSettings = {
            createMeetingUrl: ""
        };
        http:Response response = new ();
        response.statusCode = 204;
        response.server = "ballerina";
        return response;
    }
}
