import ballerina/http;

public type Store object {

    private http:Client httpClient;

    public function __init(StoreConfiguration storeConfiguration) {
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
