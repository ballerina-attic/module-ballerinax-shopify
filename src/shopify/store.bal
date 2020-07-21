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

import ballerina/http;

public type Store object {

    private http:Client httpClient;

    public function init(StoreConfiguration storeConfiguration) {
        string apiPath = HTTPS + storeConfiguration.storeName + SHOPIFY_URL + API_PATH;

        http:ClientConfiguration httpClientConfig = {
            secureSocket: storeConfiguration?.secureSocket,
            retryConfig: storeConfiguration?.retryConfig,
            timeoutInMillis: storeConfiguration.timeoutInMillis,
            followRedirects: storeConfiguration?.followRedirects
        };

        AuthenticationConfiguration authConfig = storeConfiguration.authConfiguration;
        if (authConfig is BasicAuthConfiguration) {
            httpClientConfig.auth = {
                authHandler: getAuthHandler(authConfig)
            };
        } else {
            ShopifyAuthHandler authHandler = new(authConfig.accessToken);
            httpClientConfig.auth = {
                authHandler: authHandler
            };
        }
        self.httpClient = new (apiPath, httpClientConfig);
    }

    public function getCustomerClient() returns CustomerClient {
        return new CustomerClient(self);
    }

    public function getOrderClient() returns OrderClient {
        return new OrderClient(self);
    }

    public function getProductClient() returns ProductClient {
        return new ProductClient(self);
    }

    function getHttpClient() returns http:Client {
        return self.httpClient;
    }
};
