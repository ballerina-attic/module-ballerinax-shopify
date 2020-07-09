import ballerina/http;

public type Store client object {

    private string apiPath;
    string accessToken = "";
    private http:Client httpClient;
    private CustomerClient customerClient;
    private OrderClient orderClient;
    private ProductClient productClient;
    private AuthenticationConfiguration authConfig;
    function (Store) returns http:Request getRequest = function (Store store) returns http:Request { return new;};

    public function __init(StoreConfiguration storeConfiguration) {
        self.apiPath = HTTPS + storeConfiguration.storeName + SHOPIFY_URL + API_PATH;

        http:ClientConfiguration httpClientConfig = {
            secureSocket: storeConfiguration?.secureSocket,
            retryConfig: storeConfiguration?.retryConfig,
            timeoutInMillis: storeConfiguration.timeoutInMillis
        };

        // Assigning to a variable to use inside the type guard
        AuthenticationConfiguration authConfig = storeConfiguration.authConfiguration;
        self.authConfig = authConfig;
        
        if (authConfig is BasicAuthConfiguration) {
            httpClientConfig.auth = {
                authHandler: getAuthHandler(authConfig)
            };
            self.getRequest = getRequestWithBasicAuth;
        } else {
            self.accessToken = authConfig.accessToken;
            self.getRequest = getRequestWithOAuth;
        }
        self.httpClient = new (self.apiPath, httpClientConfig);
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

    function getRequest() returns http:Request {
        if (self.authConfig is BasicAuthConfiguration) {
            return getRequestWithBasicAuth(self);
        } else {
            return getRequestWithOAuth(self);
        }
    }
};
