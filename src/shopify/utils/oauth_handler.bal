import ballerina/http;

public type ShopifyAuthHandler object {
    *http:OutboundAuthHandler;

    private string accessToken;
    public function __init(string accessToken) {
        self.accessToken = accessToken;
    }

    public function prepare(http:Request req) returns http:Request|http:AuthenticationError {
        req.setHeader(OAUTH_HEADER_KEY, self.accessToken);
        return req;
    }

    public function inspect(http:Request req, http:Response resp) returns http:Request|http:AuthenticationError? {
        
    }
};
