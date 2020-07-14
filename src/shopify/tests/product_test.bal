import ballerina/config;
import ballerina/test;
import ballerina/time;

int NUMBER_OF_PRODUCTS_LISTED = 12;

int productId = 5390405173413;
time:Time timeRecord = <time:Time>getTimeRecordFromTimeString("2020-07-07T17:01:47-04:00");
Product expectedProduct = {
    id: 5390405173413,
    title: "Sample Product 1",
    bodyHtml: "<p>Sample product body</p>",
    vendor: "Ballerina",
    productType: "Shoes",
    'handle: "sample-product-7",
    createdAt: timeRecord,
    updatedAt: timeRecord,
    publishedAt: timeRecord,
    templateSuffix: (),
    publishedScope: "web",
    tags: "",
    adminGraphqlApiId: "gid://shopify/Product/5390405173413",
    variants: [
            {
                id: 35013166006437,
                productId: 5390405173413,
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
                weightUnit: "kg",
                inventoryItemId: 37153283178661,
                inventoryQuantity: 0,
                oldInventoryQuantity: 0,
                requiresShipping: true,
                adminGraphqlApiId: "gid://shopify/ProductVariant/35013166006437"
            },
            {
                id: 35013166039205,
                productId: 5390405173413,
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
                weightUnit: "kg",
                inventoryItemId: 37153283211429,
                inventoryQuantity: 0,
                oldInventoryQuantity: 0,
                requiresShipping: true,
                adminGraphqlApiId: "gid://shopify/ProductVariant/35013166039205"
            }
        ],
    options: [
            {
                id: 6886905282725,
                productId: 5390405173413,
                name: "Colour",
                values: ["Black", "Blue"],
                position: 1
            },
            {
                id: 6886905315493,
                productId: 5390405173413,
                name: "Size",
                values: ["42", "43"],
                position: 2
            }
        ],
    images: [],
    image: ()
};

OAuthConfiguration oAuthConfiguration = {
    accessToken: config:getAsString("token")
};
StoreConfiguration storeConfiguration = {
    storeName: STORE_NAME,
    authConfiguration: oAuthConfiguration
};
Store store = new (storeConfiguration);
ProductClient productClient = store.getProductClient();

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
        test:assertEquals(product, expectedProduct);
    }
}

@test:Config {}
function getProductWithFieldsTest() {
    string[] fields = ["id", "title", "vendor"];
    Product productWithSelectedFields = {
        id: 5390405173413,
        title: "Sample Product 1",
        vendor: "Ballerina"
    };
    Product|Error product = productClient->get(productId, fields);
    if (product is Error) {
        test:assertFail(product.toString());
    } else {
        test:assertEquals(product, productWithSelectedFields);
    }
}

@test:Config {}
function getProductWithInvalidFieldsTest() {
    string[] fields = ["id", "title", "nonexisting"];
    Product productWithSelectedFields = {
        id: 5390405173413,
        title: "Sample Product 1"
    };
    Product|Error product = productClient->get(productId, fields);
    if (product is Error) {
        test:assertFail(product.toString());
    } else {
        test:assertEquals(product, productWithSelectedFields);
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
        test:assertEquals(product, productWithSelectedFields);
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
    Product[]|Error value = <Product[]|Error>nextSet?.value;
    if (value is Error) {
        test:assertFail("Error occurred while retrieving Products from the stream. " + value.toString());
    }
}

@test:Config {}
function getAllProductsWithInvalidLimitTest() {
    string expectedMessage = "The max limit must be a positive integer less than 250 (inclusive)";
    ProductFilter filter = {
        limit: 500
    };
    var getAllResult = productClient->getAll(filter);
    if (getAllResult is Error) {
        string actualMessage = getAllResult.detail()?.message.toString();
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
