import ballerina/http;
import ballerina/time;

# Represents a Shopify store.
# 
# + storeName - The name of the shopify store
# + authConfiguration - The authentication details for the store
# + timeoutInMillis - The connection timeout for a Shopify request
# + retryConfig - The `http:RetryConfig` value for retry the Shopify requests, when failed
# + secureSocket - The `http:ClientSecureSocket` configurations for secure communications
public type StoreConfiguration record {|
    string storeName;
    AuthenticationConfiguration authConfiguration;
    int timeoutInMillis = 60000;
    http:RetryConfig retryConfig?;
    http:ClientSecureSocket secureSocket?;
|};

type DateFilter record {|
    time:Time before?;
    time:Time after?;
|};

// TODO: Add documentation with the correct fields when compile fixes are done.
# Used to filter data by the created date.
public type CreatedDateFilter record {
    *DateFilter;
};

# Used to filter data by the updated date.
public type UpdatedDateFilter record {
    *DateFilter;
};

# Used to filter data by the processed date.
public type ProcessedDateFilter record {
    *DateFilter;
};

# Used to filter data by the published date.
public type PublishedDateFilter record {
    *DateFilter;
};

# Defines a basic authrization information for an app.
# 
# + username - The username or the API key for the app
# + password - The password of the username or the API key
public type BasicAuthConfiguration record {|
    string username;
    string password;
|};

# Defines an OAuth authorization information for an app. A public or a custom app must have OAuth access token to
# access to shopify stores
# 
# + accessToken - The access token for a store
public type OAuthConfiguration record {|
    string accessToken;
|};

# Represents different types of AuthenticationConfigurations for the Shopify
# store app.
public type AuthenticationConfiguration BasicAuthConfiguration|OAuthConfiguration;

# Represents additional details of as `shopify:Error`.
# 
# + message - The error message
# + cause - The root cause of the error, if there is any
# + statusCode - If the erroneous response received from the Shopify server, the HTTP status code of the response
public type Detail record {
    string message;
    error cause?;
    int statusCode?;
};

# Used to filter customers when retrieving customers.
# 
# + ids - Retrieve the customers by the provided set of ids
# + sinceId - Retrieve the customers having IDs after the given ID
# + createdDateFilter - Filters the customers by the date of creation
# + updatedDateFilter - Filters the customers by the date of updation
public type CustomerFilter record {|
    string[] ids?;
    string sinceId?;
    CreatedDateFilter createdDateFilter;
    UpdatedDateFilter updatedDateFilter;
|};

# Used to filter customers when retrieving customers.
# 
# + ids - Retrieve the customers by the provided set of ids
# + sinceId - Retrieve the customers having IDs after the given ID
# + createdDateFilter - Filters the customers by the date of creation
# + updatedDateFilter - Filters the customers by the date of updation
# + processedDateFilter - Filters the customers by the date of updation
# + attributionAppId - Filter orders attributed to a certain app, specified by the app ID
# + status - Filter orders by the order status
# + financialStatus - Filter orders by the financial status
# + fulfillmentStatus - Filter orders by the fulfillment status
public type OrderFilter record {|
    string[] ids?;
    string sinceId?;
    CreatedDateFilter createdDateFilter?;
    UpdatedDateFilter updatedDateFilter?;
    ProcessedDateFilter processedDateFilter;
    string attributionAppId?;
    OrderStatus status;
    FinancialStatus financialStatus?;
    FulfillmentStatus fulfillmentStatus?;
|};

# Used to filter products.
# 
# + ids - Retrieve the products by the provided set of ids
# + vendor - Retrieves products by a specified vendor
# + type - Filter products by the product type
# + collectionId - Filter products by the collection ID
# + createdDateFilter - Filters the products by the date of creation
# + updatedDateFilter - Filters the products by the date of updation
# + publishedDateFilter - Filters the products by the date of updation
# + publishedStatus - Filters the products by the published status of the product
public type ProductFilter record {
    string[] ids?;
    string vendor?;
    string 'type;
    string collectionId?;
    CreatedDateFilter createdDateFilter;
    UpdatedDateFilter updatedDateFilter;
    PublishedDateFilter publishedDateFilter;
    PublishedStatus publishedStatus;
};

// # Represents a Shopify customer.
// # 
// # + id - The ID of the customer. This will be set when the customer is created
// #        using `CustomerClient->create` function. Do not set this manually
// # + state - The current state of the customer. Refer `CustomerState` type for
// #           accepted values
// # + emailAddress - The email address of the customer
// # + marketingOptLevel - The level of marketing email opt of the user. This
// #                       should set to `()` if the user does not opts for
// #                       marketing mails. Refer `MarketingOptLevel` for available
// #                       values
public type Customer record {
    int id?;
    string email?;
    boolean acceptsMarketing?;
    time:Time createdAt?;
    time:Time updatedAt?;
    string firstName?;
    string lastName?;
    int ordersCount?;
    CustomerState state?;
    string totalSpent?;
    string? lastOrderId?;
    string note?;
    boolean verifiedEmail?;
    string? multipassIdentifier?;
    boolean taxExempt?;
    string phone?;
    string tags?;
    string? lastOrderName?;
    string currency?;
    Address[] addresses?;
    time:Time acceptsMarketingUpdatedAt?;
    MarketingOptLevel marketingOptInLevel?;
    string[] taxExemptions?;
    string adminGraphqlApiId?;
    Address defaultAddress?;
};

public type Invite record {

};

public type Order record {
    string? id;
    FulfillmentStatus? fulfillmentStatus;
};

public type Product record {

};

public type Address record {
    int id?;
    int customerId?;
    string firstName?;
    string lastName?;
    string company?;
    string address1?;
    string address2?;
    string city?;
    string province?;
    string country?;
    string zip?;
    string phone?;
    string name?;
    string? provinceCode?;
    string countryCode?;
    string countryName?;
    boolean 'default?;
};
