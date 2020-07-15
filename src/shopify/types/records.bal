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
import ballerina/time;

# Represents a Shopify store.
# 
# + storeName - The name of the shopify store
# + authConfiguration - The authentication configurations for the store
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

# Represents a date filter for Shopify data. This filter is used to filter data by the dates.
# 
# + before - Filter the records before this date
# + after - Filter the records after this date
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

# Represents additional information of an error. This includes the error messages sent directly from the Shopify
# server.
public type AdditionalErrorInfo record {
};

# Represents additional details of as `shopify:Error`.
# 
# + message - The error message
# + cause - The root cause of the error, if there is any
# + statusCode - If the erroneous response received from the Shopify server, the HTTP status code of the response
# + additionalErrorInfo - Any additional information about the error, including error messages from the Shopify server.
public type Detail record {
    string message;
    error cause?;
    int statusCode?;
    AdditionalErrorInfo additionalErrorInfo?;
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

# Used to search for the Customers by a provided query
# 
# + limit - The limit of Customer records per page
# + fields - Retrieve only a specific set fields of a Customer record
# + orderBy - Order the `Customer` records by a specified field
# + decending - Whether the order by decending. Default value is false
public type CustomerSearchFilter record {|
    int limit?;
    string[] fields?;
    string orderBy?;
    boolean decending = false;
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
# + fields - Retrieve only a specific set fields of a Order record. If the provided fields are incorrect, They will be
#            ignored and the valid fields are returned
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

# Used to filter the orders when retrieving the order count of a store.
# 
# + createdAt - Filter the orders by the time when the order created
# + updatedAt - Filter the orders by the time when the order updated
# + status - Filter the orders by the order status
# + financialStatus - Filter the orders by the financial status of the order
# + fulfillmentStatus - Filter the orders by the fulfillment status of the order
public type OrderCountFilter record {
    DateFilter createdAt?;
    DateFilter updatedAt?;
    OrderStatus status?;
    FinancialStatus financialStatus?;
    FulfillmentStatus fulfillmentStatus?;
};

# Used to filter products.
#
# + ids - Retrieves the products by the provided set of ids
# + limit - Number of entries per page
# + sinceId - Retrieves the products created after this ID
# + title - Filters the products by the title
# + vendor - Retrieves the products by a specified vendor
# + handle - Retrieves the products by the handle
# + productType - Filters the products by the product type
# + collectionId - Filters the products by the collection ID
# + createdAt - Filters the products by the date of creation
# + updatedAt - Filters the products by the date of updation
# + publishedAt - Filters the products by the date of publication
# + publishedStatus - Filters the products by the published status of the product
# + fields - Retrieves only a specified set of fields in `Product` record
# + presentmentCurrencies - Retrieves the products by the presentsment currency
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

# Used to filter the products when retrieving the product count of a store.
# 
# + vendor - Filter the products by its vendor
# + productType - Filter the products by it type
# + collectionId - Filter products by the product collection
# + createdAt - Filter the products by the time when the product created
# + updatedAt - Filter the products by the time when the product updated
# + publishedAt - Filter the products by the time when the product published
# + publishedStatus - Filter the products by the published status
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
# + acceptsMarketing - Whether the Customer accepts marketing emails, or not
# + acceptsMarketingUpdatedAt - The time when the Customer updated whether to accept marketing emails or not
# + addresses - The set of Addresses related to the Customer
# + adminGraphqlApiId - The graphql admin API path for the Customer
# + currency - The currecy used by the Customer
# + createdAt - The `time:Time` of the created date of the Customer
# + defaultAddress - The default address of the Customer
# + email - The email address of the customer
# + firstName - The first name of the Customer
# + id - The ID of the customer. This will be set when the customer is created using `CustomerClient->create` function.
#        Do not set this manually
# + lastName - The last Name of the Customer
# + lastOrderId - The ID of the last Order from the Customer
# + lastOrderName - The name of the last Order from the Customer
# + metafield - Define a metafield for the Customer
# + marketingOptInLevel - The level of marketing email opt of the user. This should set to `()` if the user does not
#                         opts for marketing mails. Refer `MarketingOptLevel` for available values
# + multipassIdentifier - A unique identifier for the Customer which is used with multipass login
# + note - Notes about the Customer
# + ordersCount - Number of orders belongs to the Customer
# + phone - The phone number of the Customer
# + state - The current state of the customer. Refer `CustomerState` type for accepted values
# + tags - The tags related to the Customer
# + taxExempt - Whether the Custoemr is exempted from tax
# + taxExemptions - The tax exemptions for the Customer (Canadian taxes only)
# + totalSpent - The total amount the Customer has spent
# + updatedAt - The `time:Time` of the updated date of the Customer
# + verifiedEmail - Whether the Email address of the Customer is verified or not
public type Customer record {|
    boolean acceptsMarketing?;
    time:Time acceptsMarketingUpdatedAt?;
    Address[] addresses?;
    string adminGraphqlApiId?;
    Address defaultAddress?;
    string currency?;
    time:Time createdAt?;
    string? email?;
    string? firstName?;
    int id?;
    string? lastName?;
    int? lastOrderId?;
    string? lastOrderName?;
    NewMetafield metafield?;
    MarketingOptLevel? marketingOptInLevel?;
    string? multipassIdentifier?;
    string? note?;
    int ordersCount?;
    string? phone?;
    CustomerState state?;
    string tags?;
    boolean taxExempt?;
    string[] taxExemptions?;
    string totalSpent?;
    time:Time updatedAt?;
    boolean verifiedEmail?;
|};

# Represents a new Shopify customer. This record is used for create a new Customer.
# 
# + acceptsMarketing - Whether the Customer accepts marketing emails, or not
# + acceptsMarketingUpdatedAt - The time when the Customer updated whether to accept marketing emails or not
# + addresses - The set of Addresses related to the Customer
# + email - The email address of the customer
# + firstName - The first name of the Customer
# + lastName - The last Name of the Customer
# 
# + metafield - Define a metafield for the Customer
# + multipassIdentifier - A unique identifier for the Customer which is used with multipass login
# + note - Notes about the Customer
# + phone - The phone number of the Customer
# + tags - The tags related to the Customer
# + taxExempt - Whether the Custoemr is exempted from tax
# + taxExemptions - The tax exemptions for the Customer (Canadian taxes only)
public type NewCustomer record {|
    boolean acceptsMarketing?;
    time:Time acceptsMarketingUpdatedAt?;
    Address[] addresses?;
    string? email?;
    string? firstName?;
    string? lastName?;
    NewMetafield metafield?;
    string? multipassIdentifier?;
    string? note?;
    string? phone?;
    string tags?;
    boolean taxExempt?;
    string[] taxExemptions?;
|};

# Represents an email invitation to a customer.
# 
# + to - The email address of the customer
# + from - The email address of the store
# + subject - The subject of the invitation email
# + customMessage - The message body of the invitation
# + bcc - An array of emails to BCC the invitation email
public type Invite record {
    string to?;
    string 'from?;
    string subject?;
    string customMessage?;
    string[] bcc?;
};

# Represents an `Order` in Shopify.
# 
# + appId - The ID of the app, from which the order is placed
# + billingAddress - The billing address of the order
# + browserIp - The IP of the browser, which placed the order
# + buyerAcceptsMarketing - Whether the buyer accepts marketing emails
# + cancelReason - The reason for cancelling the order, if there's any
# + cancelledAt - The time when the order is cancelled
# + cartToken - The token generated for the cart holding the order
# + checkoutId - The ID of the checkout
# + checkoutToken - The unique token generated at the checkout
# + clientDetails - The details of the cart
# + closedAt - The time when the order is closed
# + confirmed - Whether the Order is confirmed or not
# + contactEmail - The email address to contact the buyer
# + createdAt - The time when the order is created
# + currency - The currency used for the order
# + currentTotalDutiesSet - The total duties currently set for the order
# + customer - The `Customer` who ordered the order
# + customerLocale - The two or three-letter language code, optionally followed by a region modifier
# + deviceId - The ID given to the device which placed the order
# + discountApplications - The discount applications for the Order
# + discountCodes - A list of discounts applied to the Order
# + email - The customer's email address
# + financialStatus - The financial status of the Order
# + fulfillments - A list of fulfillments associated with the order
# + fulfillmentStatus - The order's status in terms of fulfilled line items
# + gateway - The payment gateway used
# + id - The ID of the Order
# + landingSite - The URL for the page where the buyer landed when they entered the shop
# + landingSiteRef - The reference to the landing site
# + lineItems - An array of `LineItem` records, each containing information about an item in the order
# + locationId - The ID of the physical location where the order was processed
# + name - The genearted name for the Order
# + note - An optional note that a shop owner can attach to the order
# + noteAttributes - Extra information that is added to the order. Appears in the Additional details section of an
#                    order details page
# + number - The order's position in the shop's count of orders
# + orderNumber - The order 's position in the shop's count of orders starting at 1001
# + originalToalDutiesSet - The original total duties charged on the order in shop and presentment currencies
# + paymentDetails - A record containing information about the payment
# + paymentGatewayNames - The list of payment gateways used for the order
# + phone - The customer's phone number for receiving SMS notifications
# + presentmentCurrency - The presentment currency that was used to display prices to the customer
# + processedAt - The time when the order was processed
# + processingMethod - How the payment was processed
# + reference - Reference to the order
# + referringSite - The website where the customer clicked a link to the shop
# + refunds - A list of refunds applied to the order
# + shippingAddress - The mailing address to where the order will be shipped
# + shippingLines - An array of `ShippingLine` records, each of which details a shipping method used
# + sourceName - Where the order originated
# + sourceIdentifier - The identifier for the source of the order
# + sourceUrl - THe URL of the source of the order
# + subtotalPrice - The price of the order in the shop currency after discounts but before shipping, taxes, and tips
# + subtotalPriceSet - The subtotal of the order in shop and presentment currencies
# + tags - Tags attached to the order, formatted as a string of comma-separated values
# + taxLines - An array of `TaxLine` records, each of which details a tax applicable to the order
# + taxesIncluded - Whether the taxes are included in the order subtotal
# + test - Whether the order is a test order
# + totalDiscounts - The total discounts applied to the price of the order in the shop currency
# + totalDiscountsSet - The total discounts applied to the price of the order in shop and presentment currencies
# + totalLineItemsPrice - The sum of all line item prices in the shop currency
# + totalLineItemsPriceSet - The total of all line item prices in shop and presentment currencies
# + totalPrice - The sum of all line item prices, discounts, shipping, taxes, and tips in the shop currency
# + totalPriceSet - The total price of the order in shop and presentment currencies
# + totalPriceUsd - The total total shipping price of the order in shop and presentment currencies
# + totalShippingPriceSet - The total price in presentment 
# + totalTax - The sum of all the taxes applied to the order in th shop currency
# + totalTaxSet - The total tax applied to the order in shop and presentment currencies
# + totalTipReceived - The sum of all the tips in the order in the shop currency
# + totalWeight - The sum of all line item weights in grams
# + updatedAt - The time when the Order was last modified
# + userId - The ID of the user logged into Shopify POS who processed the Order
# + orderStatusUrl - The URL poiting to the order status webpage
# + token - A unique token for the order
# + adminGraphqlApiId - The URL to admin GraphQL API
public type Order record {
    int appId?;
    Address billingAddress?;
    string? browserIp?;
    boolean buyerAcceptsMarketing?;
    string? cancelReason?;
    time:Time? cancelledAt?;
    string? cartToken?;
    int? checkoutId?;
    string? checkoutToken?;
    ClientDetails clientDetails?;
    time:Time? closedAt?;
    boolean confirmed?;
    string contactEmail?;
    time:Time createdAt?;
    string currency?;
    PriceSet? currentTotalDutiesSet?;
    Customer? customer?;
    string? customerLocale?;
    int? deviceId?;
    DiscountApplication[] discountApplications?;
    DiscountCode[] discountCodes?;
    string email?;
    FinancialStatus financialStatus?;
    Fulfillment[] fulfillments?;
    FulfillmentStatus? fulfillmentStatus?;
    string gateway?;
    int id?;
    string? landingSite?;
    string? landingSiteRef?;
    LineItem[] lineItems?;
    int? locationId?;
    string name?;
    string? note?;
    NoteAttribute[] noteAttributes?;
    int number?;
    int orderNumber?;
    PriceSet? originalToalDutiesSet?;
    PaymentDetails paymentDetails?;
    string[] paymentGatewayNames?;
    string? phone?;
    string presentmentCurrency?;
    time:Time? processedAt?;
    string processingMethod?; // TODO: Make this a separte type
    string? reference?;
    string? referringSite?;
    Refund[] refunds?;
    Address shippingAddress?;
    ShippingLine[] shippingLines?;
    string sourceName?;
    string? sourceIdentifier?;
    string? sourceUrl?;
    string subtotalPrice?;
    PriceSet subtotalPriceSet?;
    string tags?;
    TaxLine[] taxLines?;
    boolean taxesIncluded?;
    boolean test?;
    string token?;
    string totalDiscounts?;
    PriceSet totalDiscountsSet?;
    string totalLineItemsPrice?;
    PriceSet totalLineItemsPriceSet?;
    string totalPrice?;
    PriceSet totalPriceSet?;
    string totalPriceUsd?;
    PriceSet totalShippingPriceSet?;
    string totalTax?;
    PriceSet totalTaxSet?;
    string totalTipReceived?;
    int totalWeight?;
    time:Time updatedAt?;
    int? userId?;
    string orderStatusUrl?;
    string adminGraphqlApiId?;
};

# Represents a new order in Shopify.
# 
# + billingAddress - The billing address of the order
# + buyerAcceptsMarketing - Whether the buyer accepts marketing emails
# + cancelReason - The reason for cancelling the order, if there's any
# + checkoutId - The ID of the checkout
# + checkoutToken - The unique token generated at the checkout
# + contactEmail - The email address to contact the buyer
# + currency - The currency used for the order
# + customer - The `Customer` who ordered the order
# + discountCodes - A list of discounts applied to the Order
# + email - The customer's email address
# + financialStatus - The financial status of the Order
# + fulfillments - A list of fulfillments associated with the order
# + fulfillmentStatus - The order's status in terms of fulfilled line items
# + gateway - The payment gateway used
# + lineItems - An array of `LineItem` records, each containing information about an item in the order
# + locationId - The ID of the physical location where the order was processed
# + name - The genearted name for the Order
# + note - An optional note that a shop owner can attach to the order
# + noteAttributes - Extra information that is added to the order. Appears in the Additional details section of an
#                    order details page
# + paymentDetails - A record containing information about the payment
# + phone - The customer's phone number for receiving SMS notifications
# + presentmentCurrency - The presentment currency that was used to display prices to the customer
# + processedAt - The time when the order was processed
# + reference - Reference to the order
# + referringSite - The website where the customer clicked a link to the shop
# + shippingAddress - The mailing address to where the order will be shipped
# + shippingLines - An array of `ShippingLine` records, each of which details a shipping method used
# + sourceName - Where the order originated
# + sourceIdentifier - The identifier for the source of the order
# + sourceUrl - THe URL of the source of the order
# + subtotalPrice - The price of the order in the shop currency after discounts but before shipping, taxes, and tips
# + subtotalPriceSet - The subtotal of the order in shop and presentment currencies
# + tags - Tags attached to the order, formatted as a string of comma-separated values
# + taxLines - An array of `TaxLine` records, each of which details a tax applicable to the order
# + taxesIncluded - Whether the taxes are included in the order subtotal
# + test - Whether the order is a test order
# + totalDiscounts - The total discounts applied to the price of the order in the shop currency
# + totalDiscountsSet - The total discounts applied to the price of the order in shop and presentment currencies
# + totalLineItemsPrice - The sum of all line item prices in the shop currency
# + totalLineItemsPriceSet - The total of all line item prices in shop and presentment currencies
# + totalPrice - The sum of all line item prices, discounts, shipping, taxes, and tips in the shop currency
# + totalPriceSet - The total price of the order in shop and presentment currencies
# + totalPriceUsd - The total total shipping price of the order in shop and presentment currencies
# + totalShippingPriceSet - The total price in presentment 
# + totalTax - The sum of all the taxes applied to the order in th shop currency
# + totalTaxSet - The total tax applied to the order in shop and presentment currencies
# + totalTipReceived - The sum of all the tips in the order in the shop currency
# + totalWeight - The sum of all line item weights in grams
# + userId - The ID of the user logged into Shopify POS who processed the Order
# + metafields - Additional metafield values for the order
# + inventoryBehaviour - The inventory update behaviour. Default value is `shopify:INVENTORY_BYPASS`
# + sendReceipt - Specify whether to send an order confirmation to the customer or not. Default value is `false`
# + sendFulfillmentReceipt - Specify whether to send a shipping confirmation receipt to the customer. Default value is `false`
public type NewOrder record {
    Address billingAddress?;
    boolean buyerAcceptsMarketing?;
    string? cancelReason?;
    int? checkoutId?;
    string? checkoutToken?;
    string contactEmail?;
    string currency?;
    Customer? customer?;
    DiscountCode[] discountCodes?;
    string email?;
    FinancialStatus financialStatus?;
    Fulfillment[] fulfillments?;
    FulfillmentStatus? fulfillmentStatus?;
    string gateway?;
    LineItem[] lineItems?;
    int? locationId?;
    string name?;
    string? note?;
    NoteAttribute[] noteAttributes?;
    PaymentDetails paymentDetails?;
    string? phone?;
    string presentmentCurrency?;
    time:Time? processedAt?;
    string? reference?;
    string? referringSite?;
    Address shippingAddress?;
    ShippingLine[] shippingLines?;
    string sourceName?;
    string? sourceIdentifier?;
    string? sourceUrl?;
    string subtotalPrice?;
    PriceSet subtotalPriceSet?;
    string tags?;
    TaxLine[] taxLines?;
    boolean taxesIncluded?;
    boolean test?;
    string totalDiscounts?;
    PriceSet totalDiscountsSet?;
    string totalLineItemsPrice?;
    PriceSet totalLineItemsPriceSet?;
    string totalPrice?;
    PriceSet totalPriceSet?;
    string totalPriceUsd?;
    PriceSet totalShippingPriceSet?;
    string totalTax?;
    PriceSet totalTaxSet?;
    string totalTipReceived?;
    int totalWeight?;
    int? userId?;
    NewMetafield[] metafields?;
    InventoryBehaviour inventoryBehaviour?;
    boolean sendReceipt?;
    boolean sendFulfillmentReceipt?;
};

# Represents a Shopify product.
# 
# + bodyHtml - A description of the product. This supports HTML formatting
# + createdAt - The time when the product was created
# + handle - A unique human-friendly string for the product
# + id - The unique ID assigned for the product
# + images - An array of product `Image` records
# + image - The Image displayed at the product thumbnail
# + options - The custome product property names. A product can have upto 3 options
# + productType - A categorization for the product used for filtering and searching products
# + publishedAt - The time when the product was published. Set this to null to unpublish the product
# + publishedScope - Whether the product is published to the Point of Sale channel. The value can be "web" or "global"
# + tags - A string of comma-separated tags that are used for filtering and search
# + templateSuffix - The suffix of the Liquid template used for the product page
# + title - THe name of the product
# + updatedAt - The time when the Product was last modified
# + variants - An array of `Variant`s each representing a diffrent version of the product
# + vendor - The name of the Product's vendor
# + adminGraphqlApiId - The URL to admin GraphQL API
# + metafieldsGlobalTitleTag - The `<meta name = 'title'>` tag value. This is used for SEO purposes
# + metafieldsGlobalDescriptionTag - The `<meta name = 'description'>` tag value. This is used for SEO purposes
public type Product record {|
    string bodyHtml?;
    time:Time createdAt?;
    string 'handle?;
    int id?;
    Image? image?;
    Image[] images?;
    Option[] options?;
    string productType?;
    time:Time? publishedAt?;
    string publishedScope?;
    string tags?;
    string? templateSuffix?;
    string title?;
    time:Time updatedAt?;
    ProductVariant[] variants?;
    string vendor?;
    string adminGraphqlApiId?;
    string metafieldsGlobalTitleTag?;
    string metafieldsGlobalDescriptionTag?;
|};

# Represents a new Product in Shopify.
# 
# + bodyHtml - A description of the product. This supports HTML formatting
# + images - An array of product `Image` records
# + image - The Image displayed at the product thumbnail
# + options - The custome product property names. A product can have upto 3 options
# + published - Whether the product is currently published of not
# + productType - A categorization for the product used for filtering and searching products
# + publishedAt - The time when the product was published
# + publishedScope - Whether the product is published to the Point of Sale channel. The value can be "web" or "global"
# + tags - A string of comma-separated tags that are used for filtering and search
# + templateSuffix - The suffix of the Liquid template used for the product page
# + title - THe name of the product
# + variants - An array of `Variant`s each representing a diffrent version of the product
# + vendor - The name of the Product's vendor
# + metafields - The additional Metafields for the products
# + metafieldsGlobalTitleTag - The `<meta name = 'title'>` tag value. This is used for SEO purposes
# + metafieldsGlobalDescriptionTag - The `<meta name = 'description'>` tag value. This is used for SEO purposes
public type NewProduct record {|
    string bodyHtml?;
    Image[] images?;
    Image image?;
    Option[] options?;
    string productType?;
    boolean published?;
    time:Time? publishedAt?;
    string publishedScope?;
    string tags?;
    string? templateSuffix?;
    string title?;
    ProductVariant[] variants?;
    string vendor?;
    NewMetafield[] metafields?;
    string metafieldsGlobalTitleTag?;
    string metafieldsGlobalDescriptionTag?;
|};

# Represents a Product option.
# 
# + id - The id of the option
# + productId - The ID of the related product
# + name - The name given for the product option
# + values - The values available for the option
# + position - The position of the Option in the product options
public type Option record {
    int id?;
    int productId?;
    string name;
    string[] values;
    int position?;
};

# Represents a Variant of a Product.
# 
# + id - The unique ID of the variant
# + productId - The ID of the related product
# + title - The title of the variant
# + price - The price of the particular variant
# + sku - The stock keeping unit
# + position - The position of the variant in the product variants
# + inventoryPolicy - The inventory policy of the product variant
# + compareAtPrice - The price in which the product originally sells at
# + fulfillmentService - The shipping service of the product
# + inventoryManagement - The inventory management agent
# + option1 - The first `Option` of the variant
# + option2 - The second `Option` of the variant
# + option3 - The third `Option` of the variant
# + createdAt - THe time when the variant was created
# + updatedAt - The time when the variant was last modified
# + taxable - Whether the variant is taxable or not
# + barcode - The barcode assigned to the variant
# + grams - The weight of the variant in grams
# + imageId - The ID of the `Image` of the variant
# + weight - The weight of the variant with the packing
# + weightUnit - The unit of the weight
# + inventoryItemId - The ID of the item in the inventory
# + inventoryQuantity - The quantity of the variant available at the inventory
# + oldInventoryQuantity - The previous quantity of the inventory
# + requiresShipping - Whether the product variant needs shipping or not
# + adminGraphqlApiId - The URL to admin GraphQL API
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

# Represents an Image related to a `Product`.
# 
# + id - The ID of the image
# + productId - The ID of the product to which the image is related
# + position - The position of the image
# + createdAt - The time when the Image is created
# + updatedAt - THe time when the Image id updated
# + width - The width of the Image
# + height - The height if the Image
# + src - The URL to the image source
# + variantIds - The IDs of the variants to which the image is related
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

# Represents an Address in Shopify.
# 
# + id - The ID given to the address
# + customerId - The ID to whom the address is belonging to
# + firstName - The first name of the address owner
# + lastName - The last name of the address owner
# + company - The company name (If exists)
# + address1 - The address line 1
# + address2 - The address line 2
# + city - The city of the address
# + province - The province of the address
# + country - The country of the address
# + zip - The zip code of the address
# + phone - The phone number associated with the address
# + name - The full name of the person related to the address
# + provinceCode - The province code of the address
# + countryCode - The country code of the address
# + countryName - The country name of the address
# + default - Whether this is the default address of the customer or not
# + latitude - The latitude value of the address
# + longitude - The longitude value of the address
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

# Represents a discount in Shopify.
# 
# + type - The type of the discount
# + title -The title of the discount
# + description - The description of the discount
# + value - The discount value
# + valueType - The type of the discount value
# + allocationMethod - The discount allocation method
# + targetSelection - The target selection method
# + targetType - The type of the target
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

# Represents a Shopify discount code.
# 
# + code - The discount code to to apply the discount
# + amount - The discount amount
# + type - The doscount type
public type DiscountCode record {|
    string code;
    string amount;
    string 'type;
|};

# Represents a note atteribute
# 
# + name - The name of the note
# + value - The value of the note
public type NoteAttribute record {|
    string name;
    string value;
|};

# Represents a tax line in Shopify.
# 
# + price - The price of the tax
# + rate - The rate of the tax
# + title - The title of the tax
# + priceSet - The tax amount in shop and presentment currencies
public type TaxLine record {|
    string price;
    float rate;
    string title;
    PriceSet priceSet;
|};

# Represents a PriceSet in shopify. This includes the amount in shop and presentment currencies.
# 
# + shopMoney - The shop money value
# + presentmentMoney - The presentment value
public type PriceSet record {|
    Money shopMoney;
    Money presentmentMoney;
|};

# Represents a line item in a Shopify order.
# 
# + id - The unique ID of the line item
# + variantId - The unique ID of the variant, to which the line item belongs
# + title - The title of the line item
# + quantity - THe quantity of the line item
# + sku - The stock keeping unit
# + variantTitle - The title of the variant of the line item
# + vendor - The vendor of the line item
# + fulfillmentService - The fulfillment service used to ship the line item
# + productId - The ID of the original Product
# + requiresShipping - Whether the line item needs to be shipped or not
# + taxable - Whether the line item is taxable or not
# + giftCard - Whether the item is a gift card or not
# + name - The name of the line item
# + variantInventoryManagement - The inventory management policy of the line item
# +  properties - The additional properties of the line item
# + productExists - Whethe the product exists of not
# + fulfillableQuantity - The quantity to fulfill
# + grams - The weight of the line item in grams
# + price - The price of the line item
# + totalDiscount - The total discount applied to the line item
# + fulfillmentStatus - The fulfillment status of the line item
# + priceSet - The price set for the line item in shop and presentment currencies
# + totalDiscountSet - The total discounts applied to the line item in shop and presentment currencies
# + discountAllocations - The discount allocations for the line item
# + duties - The array of duties applied to the line item
# + adminGraphqlApiId - The URL to admin GraphQL API
# + taxLines - The array of all the tax lines applied to the line item
# + originLocation - The origin location of the line item
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

# Represents a Shopify fulfillment.
# 
# + createdAt - The time when the fulfillment created
# + id - The unique ID of the fulfillment
# + orderId - The unique ID of the order to which the fulfillment belongs to
# + status - The current status of the fulfillment
# + trackingCompany - The company which is tracking the fulfillment
# + trackingNumber - The unique ID to track the fulfillment
# + updatedAt - The time when the fulfillment last modified
public type Fulfillment record {|
    time:Time createdAt?;
    int id?;
    int orderId?;
    string status?;
    string trackingCompany?;
    string trackingNumber?;
    time:Time updatedAt?;
|};

# Represents a Shopify refund.
# 
# + id - The unique ID of the refund
# + orderId - The unique ID of the order to which the refund belongs to
# + note - A special note about the refund, if there's any
# + userId - The unique ID of the user, to whom the refund belongs to
public type Refund record {
    int id?;
    int orderId?;
    string? note?;
    int? userId?;
};

# Represents a shipping line in Shopify.
# 
# + id - The unique ID of the shipping line
# + title - The title of the shipping line
# + price -The price of the shipping line
# + code - The code of the shipping line
# + source - The source of the shipping line
# + phone - The phone belongs to the shipping line
# + requestedFulfillmentServiceId - The unique ID of the fulfillment service
# + deliveryCategory - The category of delivery
# + carrierIdentifier - The identifier for the carrier of the shipping line
# + discountedPrice - The discount amount for the shipping
# + priceSet - The price of the shipping line in shop and presentment currencies
# + discountedPriceSet - The total discount price in shop and presentment currencies
# + discountAllocations - The array of all the discount allocations for the item
# + taxLines - The array of tax lines applicable to the item
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

# Represents details of a payment in Shopify.
# 
# + creditCardBin - The credit card BIN number
# + avsResultCode - The AVS code of the credit card
# + cvvResultCode - The CVV code of the credit card
# + creditCardNumber - The credit card number used in the payment
# + creditCardCompany - The company which issued the credit card
public type PaymentDetails record {|
    string creditCardBin?;
    string? avsResultCode?;
    string? cvvResultCode?;
    string creditCardNumber?;
    string creditCardCompany?;
|};

# Represents details of a Shopify client.
# 
# + browserIp - The IP address of the browser which did the purchase
# + acceptLanguage - The language code for the language which the client is using
# + userAgent - The details of the client's agent, such as browser, OS, etc.
# + sessionHash - The client's session hash value
# + browserWidth - The width of the client's browser
# + browserHeight - The height of the client's browser
public type ClientDetails record {|
    string browserIp;
    string acceptLanguage;
    string userAgent;
    string? sessionHash;
    int browserWidth;
    int browserHeight;
|};

# Used to define an additional property of a line item.
# 
# + name - The name of the property
# + value - The value of the property
public type LineItemProperty record {|
    string name;
    string value;
|};

# Represents a discount allocation for a line item in Shopify.
# 
# + amount - The amount of the discount
# + discountApplicationIndex - The index of the discount allocation
# + amountSet - The amount of the discount in shop and presentment currencies
public type DiscountAllocation record {|
    string amount?;
    int discountApplicationIndex?;
    PriceSet amountSet?;
|};

# Represents duty details for a Shopify line item.
# 
# + id - The unique ID of the duty
# + harmonizedSystemCode - The Harmonized System Code for the duty
# + countryCodeOfOrigin - The country of origin
# + shopMoney - The value of the duty in shop currency
# + presentmentMoney - The value of the duty in presentment currency
# + taxLines - The array of all the tax lines applicable to the duty
# + adminGraphqlApiId - The URL to admin GraphQL API
public type Duty record {|
    string id?;
    string harmonizedSystemCode?;
    string countryCodeOfOrigin?;
    Money shopMoney?;
    Money presentmentMoney?;
    TaxLine[] taxLines?;
    string adminGraphqlApiId?;
|};

# Used to provide additional options when cancelling an Order.
# 
# + amount - The amount to refund
# + currency - The currency of the refund
# + note - Any additional notes about the cancellation
# + email - Whether to send an email to the customer notifying the cancellation
# + refund - The `Refund` transactions to perform. This is required for some complex refund situations
public type OrderCancellationOptions record {
    string amount?;
    string currency?;
    string note?;
    boolean email?;
    Refund refund?;
};

# Represents a location in Shopify.
# 
# + id - The unique ID of the location
# + countryCode - The two letter code for the country of the location
# + provinceCode - The two-letter abbreviation of the region of the billing address
# + name - Name of the location
# + address1 - Address line 1
# + address2 - Address line 2
# + city - City of the location
# + zip - The ZIP code of the location
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
