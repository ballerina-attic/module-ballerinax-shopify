![Shopify Continuous Integration Workflow](https://github.com/ballerina-platform/module-ballerinax-shopify/workflows/Shopify%20Continuous%20Integration%20Workflow/badge.svg)
# Ballerina Shopify Connector
This module allows to access the Shopify admin REST API though Ballerina. Shopify is a popular e-commerce platform, which enables users to create online stores easily. The Shopify admin API provides various functionalities for handling Shopify stores.

The following sections provide you details on how to use the Shopify connector.

- [Compatibility](#compatibility)
- [Feature Overview](#feature-overview)
- [Prerequisites](#Prerequisites)
- [Samples](#samples)

## Compatibility

| Ballerina Shopify Connector Version | Shopify Admin API Version | Ballerina Version |
|:-----------------------------------:|:-------------------------:|:-----------------:|
| 0.9.0                               | 2020-04                   | Swan Lake Preview1|

## Feature Overview
- Shopify connector has three different clients to handle different operations.
    - `shopify:CustomerClient`
    - `shopify:ProductClient`
    - `shopify:OrderClient`
- The `shopify:Store` object is the base of all the above clients.
- Basic (username and password based) and OAuth2 (access token based) authentication are supported.

## Prerequisites
- Download and install the compatible [Ballerina](https://ballerinalang.org/downloads/) distribution.
- Pull the Shopify module from Ballerina central.
```shell
ballerina pull ballerinax/shopify
```
- You must obtain the authentication from the [Shopify Admin API](https://shopify.dev/concepts/about-apis/authentication).

## Samples
### Shopify Customer Client
The `shopify:CustomerClient` client object can be used to handle various customer-related operations including the following.
- Create Customers
- Retrieve Customer Details
- Update Customer Details
- Delete Customers

```ballerina
import ballerina/io;
import ballerinax/shopify;

public function main() {
    io:println("Shopify Customer");
    string token = <Your Shopify Access Token>;
    shopify:OAuth2Configuration oAuth2Configuration = {
        accessToken: token
    };
    shopify:StoreConfiguration storeConfiguration = {
        storeName: <Your Shopify Store Name>,
        authConfiguration: oAuth2Configuration
    };
    // Create a Store object
    shopify:Store store = new (storeConfiguration);
    // Obtain the CustomerClient from the Store object
    shopify:CustomerClient customerClient = store.getCustomerClient();

    shopify:CustomerFilter filter = {
        // Retrieve only specific fields of a Customer
        fields: ["firstName", "lastName", "email", "id"]
    };
    // Get all the customers of the shop as a stream
    var result = customerClient->getAll(filter);
    if (result is shopify:Error) {
        io:println(result);
    } else {
        var nextSet = result.next();
        shopify:Customer[]|shopify:Error? customers = nextSet?.value;
        if (customers is shopify:Error?) {
            io:println(customers);
        } else {
            foreach shopify:Customer customer in customers {
                io:println("Name: " + customer?.firstName.toString() + " " + customer?.lastName.toString());
                io:println("ID: " + customer?.id.toString());
            }
        }
    }
```

### Shopify Product Client
The `shopify:ProductClient` client object can be used to handle various product-related operations including the following.
- Create Products
- Retrieve Products Details
- Update Products Details
- Delete Products

```ballerina
import ballerina/io;
import ballerinax/shopify;

public function main() {
    string token = <Your Shopify Access Token>;
    shopify:OAuth2Configuration oAuth2Configuration = {
        accessToken: token
    };
    shopify:StoreConfiguration storeConfiguration = {
        storeName: <Your Shopify Store Name>,
        authConfiguration: oAuth2Configuration
    };
    // Create a Store object
    shopify:Store store = new (storeConfiguration);
    // Obtain the ProductClient from the Store object
    shopify:ProductClient productClient = store.getProductClient();

    // Get the product details using the product ID
    shopify:Product|shopify:Error result = productClient->get(<Product ID>);
}
```
### Shopify Order Client
The `shopify:OrderClient` client object can be used to handle various order-related operations including the following.
- Create Orders
- Retrieve Order Details
- Update Order Details
- Cancel / Close / Reopen Orders

```ballerina
import ballerina/io;
import ballerinax/shopify;

public function main() {}
    string token = <Your Shopify Access Token>;
    shopify:OAuth2Configuration oAuth2Configuration = {
        accessToken: token
    };
    shopify:StoreConfiguration storeConfiguration = {
        storeName: <Your Shopify Store Name>,
        authConfiguration: oAuth2Configuration
    };
    // Create a Store object
    shopify:Store store = new (storeConfiguration);
    // Obtain the OrderClient from the Store object
    shopify:OrderClient orderClient = store.getOrderClient();
    // Obtain the CustomerClient from the Store object
    shopify:CustomerClient customerClient = store.getCustomerClient();

    // Retrieve the Customer to create new Order
    var customerResult = customerClient->get(<Customer ID>);
    if (customerResult is shopify:Error) {
        io:println(customerResult);
    }
    shopify:Customer customer = <shopify:Customer>customerResult;

    // Add a line item for the order
    shopify:LineItem lineItem = {
        title: <Product Variant Title>,
        variantId: <Product Variant ID>,
        productId: <Product ID>
    };

    // Add the payment details of the Order
    // The Shopify Bogus Gateway is used here
    shopify:PaymentDetails paymentDetails = {
        creditCardBin: "1",
        avsResultCode: (),
        cvvResultCode: (),
        creditCardNumber: "•••• •••• •••• 1",
        creditCardCompany: "Bogus"
    };

    // Create a NewOrder record
    shopify:NewOrder newOrder = {
        lineItems: [lineItem],
        customer: customer,
        paymentDetails: paymentDetails
    };

    // Create Order
    shopify:Order|shopify:Error orderCreationResult = orderClient->create(newOrder);
    io:println(orderClient);
}
```
