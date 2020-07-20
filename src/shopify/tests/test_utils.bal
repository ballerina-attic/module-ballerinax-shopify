// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
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

import ballerina/config;
import ballerina/io;
import ballerina/system;
import ballerina/time;

const STORE_NAME = "ballerina-test";

public type TestUtil object {
    Store store;

    public function init() {
        string token = config:getAsString("token");
        token = token == "" ? system:getEnv("shopify_token") : config:getAsString("token");
        OAuth2Configuration oAuth2Configuration = {
            accessToken: token
        };
        StoreConfiguration storeConfiguration = {
            storeName: STORE_NAME,
            authConfiguration: oAuth2Configuration
        };
        self.store = new (storeConfiguration);
    }

    function getStore() returns Store {
        return self.store;
    }
};

function printMismatches(record {} actual, record {} expected) {
    foreach string key in expected.keys() {
        var actualValue = actual[key];
        var expectedValue = expected[key];
        if (actualValue != expectedValue) {
            io:println("Key " + key + " not equal");
            if (actualValue is time:Time && expectedValue is time:Time) {
                io:println("Expected: " + getTimeStringFromTimeRecord(expectedValue) + " | " + "Received: " + getTimeStringFromTimeRecord(actualValue));
            } else {
                io:println("Expected: " + expectedValue.toString() + " | " + "Received: " + actualValue.toString());
            }
        }
    }
}
