import ballerina/config;
import ballerina/system;

const STORE_NAME = "ballerina-test";

public type TestUtil object {
    Store store;

    public function __init() {
        string token = config:getAsString("token");
        token = token == "" ? system:getEnv("shopify_token") : config:getAsString("token");
        OAuthConfiguration oAuthConfiguration = {
            accessToken: token
        };
        StoreConfiguration storeConfiguration = {
            storeName: STORE_NAME,
            authConfiguration: oAuthConfiguration
        };
        self.store = new (storeConfiguration);
    }

    function getStore() returns Store {
        return self.store;
    }
};
