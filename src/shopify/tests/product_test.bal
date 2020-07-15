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
import ballerina/time;

int NUMBER_OF_PRODUCTS_LISTED = 2;

int productId = 5383565017249;
time:Time timeRecord = <time:Time>getTimeRecordFromTimeString("2020-07-14T07:55:48-04:00");
time:Time updatedAt = <time:Time>getTimeRecordFromTimeString("2020-07-14T08:51:05-04:00");

Product expectedProduct = {
    id: productId,
    title: "Sample Product 1",
    bodyHtml: "<p>Sample product body</p>",
    vendor: "Ballerina",
    productType: "Shoes",
    'handle: "sample-product-1",
    createdAt: timeRecord,
    updatedAt: updatedAt,
    publishedAt: timeRecord,
    templateSuffix: (),
    publishedScope: "web",
    tags: "",
    adminGraphqlApiId: "gid://shopify/Product/5383565017249",
    variants: [
            {
                id: 35060410876065,
                productId: productId,
                title: "Black / 42",
                price: "100.00",
                sku: "123",
                position: 1,
                inventoryPolicy: "deny",
                compareAtPrice: (),
                fulfillmentService: "manual",
                inventoryManagement: (),
                option1: "Black",
                option2: "42",
                option3: (),
                createdAt: timeRecord,
                updatedAt: timeRecord,
                taxable: true,
                barcode: (),
                grams: 0,
                imageId: (),
                weight: 0.0,
                weightUnit: "lb",
                inventoryItemId: 37060044423329,
                inventoryQuantity: 0,
                oldInventoryQuantity: 0,
                requiresShipping: true,
                adminGraphqlApiId: "gid://shopify/ProductVariant/35060410876065"
            },
            {
                id: 35060410908833,
                productId: productId,
                title: "Blue / 43",
                price: "150.00",
                sku: "123",
                position: 2,
                inventoryPolicy: "deny",
                compareAtPrice: (),
                fulfillmentService: "manual",
                inventoryManagement: (),
                option1: "Blue",
                option2: "43",
                option3: (),
                createdAt: timeRecord,
                updatedAt: timeRecord,
                taxable: true,
                barcode: (),
                grams: 0,
                imageId: (),
                weight: 0.0,
                weightUnit: "lb",
                inventoryItemId: 37060044456097,
                inventoryQuantity: 0,
                oldInventoryQuantity: 0,
                requiresShipping: true,
                adminGraphqlApiId: "gid://shopify/ProductVariant/35060410908833"
            }
        ],
    options: [
            {
                id: 6874400915617,
                productId: productId,
                name: "Colour",
                values: ["Black", "Blue"],
                position: 1
            },
            {
                id: 6874400948385,
                productId: productId,
                name: "Size",
                values: ["42", "43"],
                position: 2
            }
        ],
    images: [],
    image: ()
};

TestUtil productTestUtil = new;
ProductClient productClient = productTestUtil.getStore().getProductClient();

@test:Config {}
function createProductTest() {
    Option option1 = {
        name: "Colour",
        values: ["Black", "Blue", "Green"]
    };

    Option option2 = {
        name: "Size",
        values: ["41", "42", "43"]
    };

    ProductVariant variant1 = {
        option1: "Black",
        option2: "42",
        price: "100.00",
        sku: "123"
    };

    ProductVariant variant2 = {
        option1: "Blue",
        option2: "43",
        price: "150.00",
        sku: "123"
    };
    NewProduct product = {
        title: "Sample Product 1",
        bodyHtml: "<p>Sample product body</p>",
        vendor: "Ballerina",
        productType: "Shoes",
        variants: [variant1, variant2],
        options: [option1, option2]
    };
    Product|Error result = productClient->create(product);
    if (result is Error) {
        test:assertFail("Failed to create product: " + result.toString());
    } else {
        createdProductId = <@untainted int>result?.id;
    }
}

int createdProductId = -999;

@test:Config {
    dependsOn: ["createProductTest"]
}
function deleteProductTest() {
    Error? result = productClient->delete(createdProductId);
    if (result is Error) {
        test:assertFail(result.toString());
    }
}

@test:Config {}
function getProductTest() {
    Product|Error product = productClient->get(productId);
    if (product is Error) {
        test:assertFail(product.toString());
    } else {
        if (product != expectedProduct) {
            printMismatches(product, expectedProduct);
            test:assertFail("productClient->get() returned unexpected Product");
        }
    }
}

@test:Config {}
function getProductWithFieldsTest() {
    string[] fields = ["id", "title", "vendor"];
    Product productWithSelectedFields = {
        id: productId,
        title: "Sample Product 1",
        vendor: "Ballerina"
    };
    Product|Error product = productClient->get(productId, fields);
    if (product is Error) {
        test:assertFail(product.toString());
    } else {
        if (product != productWithSelectedFields) {
            printMismatches(product, productWithSelectedFields);
            test:assertFail("productClient->get() returned unexpected Product");
        }
    }
}

@test:Config {}
function getProductWithInvalidFieldsTest() {
    string[] fields = ["id", "title", "nonexisting"];
    Product productWithSelectedFields = {
        id: productId,
        title: "Sample Product 1"
    };
    Product|Error product = productClient->get(productId, fields);
    if (product is Error) {
        test:assertFail(product.toString());
    } else {
        if (product != productWithSelectedFields) {
            printMismatches(product, productWithSelectedFields);
            test:assertFail("productClient->get() returned unexpected Product");
        }
    }
}

@test:Config {}
function getProductWithAllInvalidFieldsTest() {
    string[] fields = ["invalid", "anotherInvalidField", "nonexisting"];
    // This should return an empty record since the provided fields does not exist
    Product productWithSelectedFields = {};
    Product|Error product = productClient->get(productId, fields);
    if (product is Error) {
        test:assertFail(product.toString());
    } else {
        if (product != productWithSelectedFields) {
            printMismatches(product, productWithSelectedFields);
            test:assertFail("productClient->get() returned unexpected Product");
        }
    }
}

@test:Config {}
function getAllProductsTest() {
    var getAllResult = productClient->getAll();
    if (getAllResult is Error) {
        test:assertFail("Failed to retrieve Products. " + getAllResult.toString());
    }
    stream<Product[]|Error> productStream = <stream<Product[]|Error>>getAllResult;
    var nextSet = productStream.next();

    if (nextSet is ()) {
        test:assertFail("No records received");
    }
    var value = <Product[]|Error>nextSet?.value;
    if (value is Error) {
        test:assertFail("Error occurred while retrieving Products from the stream. " + value.toString());
    }
}

@test:Config {}
function getAllProductsWithInvalidLimitTest() {
    string expectedMessage = "The max limit must be a positive integer less than 250 (inclusive)";
    ProductFilter filter = {
        'limit: 500
    };
    var getAllResult = productClient->getAll(filter);
    if (getAllResult is Error) {
        string actualMessage = getAllResult.message();
        test:assertEquals(actualMessage, expectedMessage);
    } else {
        test:assertFail("Invalid limit for a page did not return an error");
    }
}

@test:Config {}
function getProductCountTest() {
    int|Error result = productClient->getCount();
    if (result is Error) {
        test:assertFail(result.toString());
    } else {
        test:assertEquals(result, NUMBER_OF_PRODUCTS_LISTED);
    }
}
