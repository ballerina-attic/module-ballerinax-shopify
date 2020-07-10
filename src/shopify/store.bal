import ballerina/http;

public type Store object {

    private http:Client httpClient;
    private CustomerClient customerClient;
    private OrderClient orderClient;
    private ProductClient productClient;

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
        // TODO: Init the clients on demand
        self.httpClient = new (apiPath, httpClientConfig);
        self.customerClient = new(self);
        self.orderClient = new(self);
        self.productClient = new(self);
    }

    public function getCustomerClient() returns CustomerClient {
        return self.customerClient;
    }

    public function getOrderClient() returns OrderClient {
        return self.orderClient;
    }

    public function getProductClient() returns ProductClient {
        return self.productClient;
    }

    function getHttpClient() returns http:Client {
        return self.httpClient;
    }
};
