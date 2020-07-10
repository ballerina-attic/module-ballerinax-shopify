import ballerina/http;
import ballerina/time;

# Represents a Shopify store.
# 
# + storeName - The name of the shopify store
# + authConfiguration - The authentication details for the store
# + timeoutInMillis - The connection timeout for a Shopify request
# + retryConfig - The `http:RetryConfig` value for retry the Shopify requests, when failed
# + secureSocket - The `http:ClientSecureSocket` configurations for secure communications
# + followRedirects - The `http:FollowRedirects` configuration to enable/configure redirects
public type StoreConfiguration record {|
    string storeName;
    AuthenticationConfiguration authConfiguration;
    int timeoutInMillis = 60000;
    http:RetryConfig retryConfig?;
    http:ClientSecureSocket secureSocket?;
    http:FollowRedirects followRedirects?;
|};

public type DateFilter record {|
    time:Time before?;
    time:Time after?;
|};

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
    //TODO: Add error response fields here
};  

# Used to filter customers when retrieving customers.
# 
# + ids - Retrieve the customers by the provided set of ids
# + sinceId - Retrieve the customers having IDs after the given ID
# + createdAt - Filters the customers by the date of creation
# + updatedAt - Filters the customers by the date of updation
# + limit - Number of records per page. The default value is 50. Maximum value is 250
# + fields - Retrieve only a specific set fields of a Customer record
public type CustomerFilter record {|
    int[] ids?;
    int sinceId?;
    DateFilter createdAt?;
    DateFilter updatedAt?;
    int 'limit?;
    string[] fields?;
|};

# Used to filter orders when retrieving orders.
# 
# + ids - Retrieve the orders by the provided set of ids
# + limit - The limit of records per page
# + sinceId - Retrieve the orders having IDs after the given ID
# + createdAt - Filters the orders by the date of creation
# + updatedAt - Filters the ordres by the date of updation
# + processedAt - Filters the ordres by the date of updation
# + attributionAppId - Filter orders attributed to a certain app, specified by the app ID
# + status - Filter orders by the order status
# + financialStatus - Filter orders by the financial status
# + fulfillmentStatus - Filter orders by the fulfillment status
# + fields - Retrieve only a specific set fields of a Order record
public type OrderFilter record {|
    string[] ids?;
    int limit?;
    string sinceId?;
    DateFilter createdAt?;
    DateFilter updatedAt?;
    DateFilter processedAt?;
    string attributionAppId?;
    OrderStatus status?;
    FinancialStatus financialStatus?;
    FulfillmentStatus fulfillmentStatus?;
    string[] fields?;
|};

public type OrderCountFilter record {
    DateFilter createdAt?;
    DateFilter updatedAt?;
    OrderStatus status?;
    FinancialStatus financialStatus?;
    FulfillmentStatus fulfillmentStatus?;
};

// # Used to filter products.
// #
// # + ids - Retrieve the products by the provided set of ids
// # + limit - Number of entries per page
// # + vendor - Retrieves products by a specified vendor
// # + productType - Filter products by the product type
// # + collectionId - Filter products by the collection ID
// # + createdDateFilter - Filters the products by the date of creation
// # + updatedDateFilter - Filters the products by the date of updation
// # + publishedDateFilter - Filters the products by the date of updation
// # + publishedStatus - Filters the products by the published status of the product
public type ProductFilter record {
    int[] ids?;
    int limit?;
    int sinceId?;
    string title?;
    string vendor?;
    string 'handle?;
    string productType?;
    int collectionId?;
    DateFilter createdAt?;
    DateFilter updatedAt?;
    DateFilter publishedAt?;
    PublishedStatus publishedStatus?;
    string[] fields?;
    string presentmentCurrencies?;
};

public type ProductCountFilter record {
    string vendor?;
    string productType?;
    int collectionId?;
    DateFilter createdAt?;
    DateFilter updatedAt?;
    DateFilter publishedAt?;
    PublishedStatus publishedStatus?;
};

# Represents a Shopify customer.
# 
# + id - The ID of the customer. This will be set when the customer is created using `CustomerClient->create` function.
#        Do not set this manually
# + email - The email address of the customer
# + acceptsMarketing - Whether the Customer accepts marketing emails, or not
# + createdAt - The `time:Time` of the created date of the Customer
# + updatedAt - The `time:Time` of the updated date of the Customer
# + firstName - The first name of the Customer
# + lastName - The last Name of the Customer
# + ordersCount - Number of orders belongs to the Customer
# + state - The current state of the customer. Refer `CustomerState` type for accepted values
# + totalSpent - The total amount the Customer has spent
# + lastOrderId - The ID of the last Order from the Customer
# + note - Notes about the Customer
# + verifiedEmail - Whether the Email address of the Customer is verified or not
# + multipassIdentifier - A unique identifier for the Customer which is used with multipass login
# + taxExempt - Whether the Custoemr is exempted from tax
# + phone - The phone number of the Customer
# + tags - The tags related to the Customer
# + lastOrderName - The name of the last Order from the Customer
# + currency - The currecy used by the Customer
# + addresses - The set of Addresses related to the Customer
# + acceptsMarketingUpdatedAt - The time when the Customer updated whether to accept marketing emails or not
# + marketingOptInLevel - The level of marketing email opt of the user. This should set to `()` if the user does not
#                         opts for marketing mails. Refer `MarketingOptLevel` for available values
# + taxExemptions - The tax exemptions for the Customer (Canadian taxes only)
# + adminGraphqlApiId - The graphql admin API path for the Customer
# + defaultAddress - The default address of the Customer
public type Customer record {
    int id?;
    string? email?;
    boolean acceptsMarketing?;
    time:Time createdAt?;
    time:Time updatedAt?;
    string? firstName?;
    string? lastName?;
    int ordersCount?;
    CustomerState state?;
    float totalSpent?;
    string? lastOrderId?;
    string? note?;
    boolean verifiedEmail?;
    string? multipassIdentifier?;
    boolean taxExempt?;
    string? phone?;
    string tags?;
    string? lastOrderName?;
    string currency?;
    Address[] addresses?;
    time:Time acceptsMarketingUpdatedAt?;
    MarketingOptLevel? marketingOptInLevel?;
    string[] taxExemptions?;
    string adminGraphqlApiId?;
    Address defaultAddress?;
};

# Represents a new Shopify customer. This record is used for create a new Customer.
# 
# + firstName - The first name of the Customer
# + lastName - The last Name of the Customer
# + email - The email address of the customer
# + phone - The phone number of the Customer
# + tags - The tags related to the Customer
# + verifiedEmail - Whether the email is verified or not
# + addresses - The set of Addresses related to the Customer
# + password - The password of the Customer
# + passwordConfirmation - Confirm the password
# + note - Notes about the Customer
# + sendEmailInvite - Whether to send the invite to the Customer when creating
# + sendEmailWelcome - Whether to send the welcome email to the Customer
# + acceptsMarketing - Whether the Customer accepts the marketing emails
# + metafields - Metafield values for the Customer
public type NewCustomer record {|
    string firstName?;
    string lastName?;
    string email?;
    string phone?;
    string tags?;
    boolean verifiedEmail?;
    Address[] addresses?;
    string password?;
    string passwordConfirmation?;
    string note?;
    boolean sendEmailInvite?;
    boolean sendEmailWelcome?;
    boolean acceptsMarketing?;
    NewMetafield[] metafields?;
|};

public type Invite record {

};

public type Order record {
    int id?;
    string email?;
    time:Time? closedAt?;
    time:Time createdAt?;
    time:Time updatedAt?;
    time:Time? cancelledAt?;
    time:Time? processedAt?;
    int number?;
    string? note?;
    string token?;
    string gateway?;
    boolean test?;
    string totalPrice?;
    string subtotalPrice?;
    int totalWeight?;
    string totalTax?;
    boolean taxesIncluded?;
    string currency?;
    FinancialStatus financialStatus?;
    boolean confirmed?;
    string totalDiscounts?;
    string totalLineItemsPrice?;
    string cartToken?;
    boolean buyerAcceptsMarketing?;
    string name?;
    string referringSite?;
    string landingSite?;
    string? cancelReason?;
    string totalPriceUsd?;
    string checkoutToken?;
    string? reference?;
    int? userId?;
    int? locationId?;
    string? sourceIdentifier?;
    string? sourceUrl?;
    int? deviceId?;
    string? phone?;
    string customerLocale?;
    int appId?;
    string browserIp?;
    string? landingSiteRef?;
    int orderNumber?;
    DiscountApplication[] discountApplications?;
    DiscountCode[] discountCodes?;
    NoteAttribute[] noteAttributes?;
    string[] paymentGatewayNames?;
    string processingMethod?;
    int checkoutId?;
    string sourceName?;
    FulfillmentStatus? fulfillmentStatus?;
    TaxLine[] taxLines?;
    string tags?;
    string contactEmail?;
    string orderStatusUrl?;
    string presentmentCurrency?;
    PriceSet totalLineItemsPriceSet?;
    PriceSet totalDiscountsSet?;
    PriceSet totalShippingPriceSet?;
    PriceSet subtotalPriceSet?;
    PriceSet totalPriceSet?;
    PriceSet totalTaxSet?;
    LineItem[] lineItems?;
    Fulfillment[] fulfillments?;
    Refund[] refunds?;
    string totalTipReceived?;
    PriceSet? originalToalDutiesSet?;
    PriceSet? currentTotalDutiesSet?;
    string adminGraphqlApiId?;
    ShippingLine[] shippingLines?;
    Address billingAddress?;
    Address shippingAddress?;
    ClientDetails clientDetails?;
    PaymentDetails paymentDetails?;
    Customer? customer?;
};


// # + sendConfirmationReceipt - Specify whether to send an order confirmation to the customer or not. Default value is `false`
// # + sendFulfillmentReceipt - Specify whether to send a shipping confirmation receipt to the customer. Default value is `false`
// # + inventoryBehaviour - The inventory update behavior. Default value is `shopify:INVENTORY_BYPASS`
public type NewOrder record {
    string email?;
    string? note?;
    string gateway?;
    boolean test?;
    string totalPrice?;
    string subtotalPrice?;
    int totalWeight?;
    string totalTax?;
    boolean taxesIncluded?;
    string currency?;
    FinancialStatus financialStatus?;
    boolean confirmed?;
    string totalDiscounts?;
    string totalLineItemsPrice?;
    boolean buyerAcceptsMarketing?;
    string name?;
    string referringSite?;
    string? cancelReason?;
    string totalPriceUsd?;
    string checkoutToken?;
    string? reference?;
    int? userId?;
    int? locationId?;
    string? sourceIdentifier?;
    string? sourceUrl?;
    int? deviceId?;
    string? phone?;
    string? landingSiteRef?;
    DiscountCode[] discountCodes?;
    NoteAttribute[] noteAttributes?;
    int checkoutId?;
    string sourceName?;
    FulfillmentStatus? fulfillmentStatus?;
    TaxLine[] taxLines?;
    string tags?;
    string contactEmail?;
    string presentmentCurrency?;
    PriceSet totalLineItemsPriceSet?;
    PriceSet totalDiscountsSet?;
    PriceSet totalShippingPriceSet?;
    PriceSet subtotalPriceSet?;
    PriceSet totalPriceSet?;
    PriceSet totalTaxSet?;
    LineItem[] lineItems;
    Fulfillment[] fulfillments?;
    string totalTipReceived?;
    string adminGraphqlApiId?;
    ShippingLine[] shippingLines?;
    Address billingAddress?;
    Address shippingAddress?;
    PaymentDetails paymentDetails?;
    Customer? customer?;
    NewMetafield[] metafields?;
    InventoryBehaviour inventoryBehavior?;
    boolean sendReceipt?;
    boolean sendFulfillmentReceipt?;
};

public type Product record {|
    int id?;
    string title?;
    string bodyHtml?;
    string vendor?;
    string productType?;
    string 'handle?;
    time:Time createdAt?;
    time:Time updatedAt?;
    time:Time publishedAt?;
    string? templateSuffix?;
    string publishedScope?;
    string tags?;
    string adminGraphqlApiId?;
    ProductVariant[] variants?;
    Option[] options?;
    Image[] images?;
    Image? image?;
    string metafieldsGlobalTitleTag?;
    string metafieldsGlobalDescriptionTag?;
|};


// # + metafieldsGlobalTitleTag - The `<meta name = 'title'>` tag value. This is used for SEO purposes
// # + metafieldsGlobalDescriptionTag - The `<meta name = 'description'>` tag value. This is used for SEO purposes
public type NewProduct record {|
    string title;
    string bodyHtml?;
    string vendor?;
    string productType?;
    ProductVariant[] variants?;
    Option[] options?;
    NewMetafield[] metafields?;
    boolean published = true;
    string metafieldsGlobalTitleTag?;
    string metafieldsGlobalDescriptionTag?;
|};

public type Option record {
    int id?;
    int productId?;
    string name;
    string[] values;
    int position?;
};

public type ProductVariant record {|
    int id?;
    int productId?;
    string title?;
    string price;
    string sku?;
    int position?;
    InventoryPolicy inventoryPolicy?;
    string? compareAtPrice?;
    string fulfillmentService?;
    string? inventoryManagement?;
    string? option1?;
    string? option2?;
    string? option3?;
    time:Time createdAt?;
    time:Time updatedAt?;
    boolean taxable?;
    string? barcode?;
    int grams?;
    string? imageId?;
    float weight?;
    string weightUnit?;
    int inventoryItemId?;
    int inventoryQuantity?;
    int oldInventoryQuantity?;
    boolean requiresShipping?;
    string adminGraphqlApiId?;
|};

public type Image record {|
    int id;
    int productId;
    int position;
    time:Time createdAt;
    time:Time updatedAt;
    int width?;
    int height?;
    string src?;
    int[] variantIds?;
|};

public type Address record {
    int id?;
    int customerId?;
    string firstName?;
    string lastName?;
    string? company?;
    string address1?;
    string address2?;
    string city?;
    string? province?;
    string country?;
    string zip?;
    string? phone?;
    string name?;
    string? provinceCode?;
    string countryCode?;
    string countryName?;
    boolean 'default?;
    string? latitude?;
    string? longitude?;
};

# Represents a metafield.
# 
# + key - The key of the metafield
# + value - The value of the metafield
# + valueType - The type of the metafield value. This can be a shopify:INTEGER, a shopify:STRING or a
#               shopify:JSON_STRING
# + namespace - The namespace in which the metafield is used
public type NewMetafield record {
    string key;
    string value;
    MetaFieldValueType valueType;
    string namespace;
};

# Represents a amount of money.
# 
# + amount - The amount of the money
# + currencyCode - The currency of the money
public type Money record {|
    string amount;
    string currencyCode;
|};

public type DiscountApplication record {|
    string 'type?;
    string title?;
    string description?;
    string value?;
    string valueType?;
    string allocationMethod?;
    string targetSelection?;
    string targetType?;
|};

public type DiscountCode record {|
    string code;
    string amount;
    string 'type;
|};

public type NoteAttribute record {|
    string name;
    string value;
|};

public type TaxLine record {|
    string price;
    float rate;
    string title;
    PriceSet priceSet;
|};

public type PriceSet record {|
    Money shopMoney;
    Money presentmentMoney;
|};

public type LineItem record {
    int id?;
    int variantId?;
    string title?;
    int quantity?;
    string sku?;
    string variantTitle?;
    string vendor?;
    string fulfillmentService?;
    int productId?;
    boolean requiresShipping?;
    boolean taxable?;
    boolean giftCard?;
    string name?;
    string? variantInventoryManagement?;
    LineItemProperty[] properties?;
    boolean productExists?;
    int fulfillableQuantity?;
    int grams?;
    string price?;
    string totalDiscount?;
    FulfillmentStatus? fulfillmentStatus?;
    PriceSet priceSet?;
    PriceSet totalDiscountSet?;
    DiscountAllocation[] discountAllocations?;
    Duty[] duties?;
    string adminGraphqlApiId?;
    TaxLine[] taxLines?;
    Location originLocation?;
};

public type Fulfillment record {|
    time:Time createdAt?;
    int id?;
    int orderId?;
    string status?;
    string trackingCompany?;
    string trackingNumber?;
    time:Time updatedAt?;
|};

// TODO: Complete record fields
public type Refund record {
    int id?;
    int orderId?;
    string? note?;
    int? userId?;
};

public type ShippingLine record {|
    int id?;
    string title?;
    string price?;
    string code?;
    string 'source?;
    string? phone?;
    int? requestedFulfillmentServiceId?;
    string? deliveryCategory?;
    string? carrierIdentifier?;
    string discountedPrice?;
    PriceSet priceSet?;
    PriceSet discountedPriceSet?;
    DiscountAllocation[] discountAllocations?;
    TaxLine[] taxLines?;
|};

public type PaymentDetails record {|
    string creditCardBin?;
    string? avsResultCode?;
    string? cvvResultCode?;
    string creditCardNumber?;
    string creditCardCompany?;
|};

public type ClientDetails record {|
    string browserIp;
    string acceptLanguage;
    string userAgent;
    string? sessionHash;
    int browserWidth;
    int browserHeight;
|};

public type LineItemProperty record {|
    string name;
    string value;
|};

public type DiscountAllocation record {|
    string amount?;
    int discountApplicationIndex?;
    PriceSet amountSet?;
|};

public type Duty record {|
    string id?;
    string harmonizedSystemCode?;
    string countryCodeOfOrigin?;
    Money shopMoney?;
    Money presentmentMoney?;
    TaxLine[] taxLines?;
    string adminGraphqlApiId?;
|};

public type Location record {|
    int id?;
    string countryCode?;
    string provinceCode?;
    string name?;
    string address1?;
    string address2?;
    string city?;
    string zip?;
|};
