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

import ballerina/test;

TestUtil orderTestUtil = new;
OrderClient orderClient = orderTestUtil.getStore().getOrderClient();

int orderId = 2569318891681;
json expectedOrderJson = {
    "id": 2569318891681,
    "email": "john.doe@example.com",
    "closedAt": null,
    "createdAt": "2020-07-14T08:45:59-04:00",
    "updatedAt": "2020-07-14T08:46:00-04:00",
    "number": 1,
    "note": null,
    "token": "cb3eda1cb7e0eca9e602476130f40627",
    "gateway": "",
    "test": false,
    "totalPrice": "100.00",
    "subtotalPrice": "100.00",
    "totalWeight": 0,
    "totalTax": "0.00",
    "taxesIncluded": false,
    "currency": "USD",
    "financialStatus": "paid",
    "confirmed": true,
    "totalDiscounts": "0.00",
    "totalLineItemsPrice": "100.00",
    "cartToken": null,
    "buyerAcceptsMarketing": false,
    "name": "#1001",
    "referringSite": null,
    "landingSite": null,
    "cancelledAt": null,
    "cancelReason": null,
    "totalPriceUsd": "100.00",
    "checkoutToken": null,
    "reference": null,
    "userId": null,
    "locationId": null,
    "sourceIdentifier": null,
    "sourceUrl": null,
    "processedAt": "2020-07-14T08:45:59-04:00",
    "deviceId": null,
    "phone": null,
    "customerLocale": null,
    "appId": 4095187,
    "browserIp": null,
    "landingSiteRef": null,
    "orderNumber": 1001,
    "discountApplications": [],
    "discountCodes": [],
    "noteAttributes": [],
    "paymentGatewayNames": [],
    "processingMethod": "",
    "checkoutId": null,
    "sourceName": "4095187",
    "fulfillmentStatus": null,
    "taxLines": [],
    "tags": "",
    "contactEmail": "john.doe@example.com",
    "orderStatusUrl": "https://ballerina-test.myshopify.com/43359142049/orders/cb3eda1cb7e0eca9e602476130f40627/authenticate?key=6e79b414331b5449da4460d681409096",
    "presentmentCurrency": "USD",
    "totalLineItemsPriceSet": {
        "shopMoney": {
            "amount": "100.00",
            "currencyCode": "USD"
        },
        "presentmentMoney": {
            "amount": "100.00",
            "currencyCode": "USD"
        }
    },
    "totalDiscountsSet": {
        "shopMoney": {
            "amount": "0.00",
            "currencyCode": "USD"
        },
        "presentmentMoney": {
            "amount": "0.00",
            "currencyCode": "USD"
        }
    },
    "totalShippingPriceSet": {
        "shopMoney": {
            "amount": "0.00",
            "currencyCode": "USD"
        },
        "presentmentMoney": {
            "amount": "0.00",
            "currencyCode": "USD"
        }
    },
    "subtotalPriceSet": {
        "shopMoney": {
            "amount": "100.00",
            "currencyCode": "USD"
        },
        "presentmentMoney": {
            "amount": "100.00",
            "currencyCode": "USD"
        }
    },
    "totalPriceSet": {
        "shopMoney": {
            "amount": "100.00",
            "currencyCode": "USD"
        },
        "presentmentMoney": {
            "amount": "100.00",
            "currencyCode": "USD"
        }
    },
    "totalTaxSet": {
        "shopMoney": {
            "amount": "0.00",
            "currencyCode": "USD"
        },
        "presentmentMoney": {
            "amount": "0.00",
            "currencyCode": "USD"
        }
    },
    "lineItems": [
            {
                "id": 5611083137185,
                "variantId": 35060410876065,
                "title": "Sample Product 1",
                "quantity": 1,
                "sku": "123",
                "variantTitle": "Black / 42",
                "vendor": "Ballerina",
                "fulfillmentService": "manual",
                "productId": 5383565017249,
                "requiresShipping": true,
                "taxable": true,
                "giftCard": false,
                "name": "Sample Product 1 - Black / 42",
                "variantInventoryManagement": null,
                "properties": [],
                "productExists": true,
                "fulfillableQuantity": 1,
                "grams": 0,
                "price": "100.00",
                "totalDiscount": "0.00",
                "fulfillmentStatus": null,
                "priceSet": {
                    "shopMoney": {
                        "amount": "100.00",
                        "currencyCode": "USD"
                    },
                    "presentmentMoney": {
                        "amount": "100.00",
                        "currencyCode": "USD"
                    }
                },
                "totalDiscountSet": {
                    "shopMoney": {
                        "amount": "0.00",
                        "currencyCode": "USD"
                    },
                    "presentmentMoney": {
                        "amount": "0.00",
                        "currencyCode": "USD"
                    }
                },
                "discountAllocations": [],
                "duties": [],
                "adminGraphqlApiId": "gid://shopify/LineItem/5611083137185",
                "taxLines": []
            }
        ],
    "fulfillments": [],
    "refunds": [],
    "totalTipReceived": "0.0",
    "originalTotalDutiesSet": null,
    "currentTotalDutiesSet": null,
    "adminGraphqlApiId": "gid://shopify/Order/2569318891681",
    "shippingLines": [],
    "customer": {
        "id": 3776780173473,
        "email": "john.doe@example.com",
        "acceptsMarketing": false,
        "createdAt": "2020-07-14T05:09:09-04:00",
        "updatedAt": "2020-07-14T08:46:00-04:00",
        "firstName": "John",
        "lastName": "Doe",
        "ordersCount": 1,
        "state": "disabled",
        "totalSpent": "100.00",
        "lastOrderId": 2569318891681,
        "note": null,
        "verifiedEmail": true,
        "multipassIdentifier": null,
        "taxExempt": false,
        "phone": "+94714567890",
        "tags": "",
        "lastOrderName": "#1001",
        "currency": "USD",
        "acceptsMarketingUpdatedAt": "2020-07-14T08:46:00-04:00",
        "marketingOptInLevel": null,
        "taxExemptions": [],
        "adminGraphqlApiId": "gid://shopify/Customer/3776780173473",
        "defaultAddress": {
            "id": 4494995980449,
            "customerId": 3776780173473,
            "firstName": "John",
            "lastName": "Doe",
            "company": "example",
            "address1": "number",
            "address2": "at street",
            "city": "at city",
            "province": "",
            "country": "Sri Lanka",
            "zip": "40404",
            "phone": "+94734567890",
            "name": "John Doe",
            "provinceCode": null,
            "countryCode": "LK",
            "countryName": "Sri Lanka",
            "default": true
        }
    }
};

@test:Config {}
function getAllOrdersTest() returns Error? {
    Order expectedOrder = check getOrderFromJson(expectedOrderJson);
    var getAllResult = orderClient->getAll();

    if (getAllResult is Error) {
        test:assertFail("Failed to retrieve Orders. " + getAllResult.toString());
    }
    stream<Order[]|Error> orderStream = <stream<Order[]|Error>>getAllResult;
    var nextSet = orderStream.next();

    if (nextSet is ()) {
        test:assertFail("No records received");
    }
    Order[]|Error value = <Order[]|Error>nextSet?.value;
    if (value is Error) {
        test:assertFail("Error occurred while retrieving Orders from the stream. " + value.toString());
    }
}

@test:Config {}
function getOrderTest() returns Error? {
    Order expectedOrder = check getOrderFromJson(expectedOrderJson);
    Order|Error actualOrder = orderClient->get(orderId);
    if (actualOrder is Error) {
        test:assertFail("Failed to retrive the order count. " + actualOrder.toString());
    } else {
        test:assertEquals(actualOrder, expectedOrder);
    }
}

@test:Config {}
function getOrderCountTest() {
    int|Error count = orderClient->getCount();
    if (count is Error) {
        test:assertFail("Failed to retrive the order count. " + count.toString());
    } else {
        test:assertEquals(count, 1);
    }
}
