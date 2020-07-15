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

function getAllProducts(ProductClient productClient, ProductFilter? filter) returns @tainted stream<Product[]>|Error {
    string queryParams = "";
    if (filter is ProductFilter) {
        queryParams = check buildQueryParamtersFromFilter(filter);
    }
    string path = PRODUCT_API_PATH + JSON + queryParams;

    ProductStream productStream = new (path, productClient);
    return new stream <Product[]|Error, Error>(productStream);
}

function getProductCount(ProductClient productClient, ProductCountFilter? filter) returns @tainted int|Error {
    string queryParams = "";
    if (filter is ProductCountFilter) {
        queryParams = check buildQueryParamtersFromFilter(filter);
    }
    string path = PRODUCT_API_PATH + COUNT_PATH + JSON;
    http:Response response = check getResponseForGetCall(productClient.getStore(), path);

    json payload = check getJsonPayload(response);
    map<json> jsonMap = <map<json>>payload;
    return getIntValueFromJson(COUNT, jsonMap);
}

function getProduct(ProductClient productClient, int id, string[]? fields) returns @tainted Product|Error {
    string queryParams = "";
    if (fields is string[]) {
        queryParams = "?" + FIELDS + "=" + buildCommaSeparatedListFromArray(fields);
    }
    string path = PRODUCT_API_PATH + "/" + id.toString() + JSON + queryParams;
    http:Response response = check getResponseForGetCall(productClient.getStore(), path);
    json payload = check getJsonPayload(response);
    json productJson = <json>payload.product;
    return getProductFromJson(productJson);
}

function createProduct(ProductClient productClient, NewProduct product) returns @tainted Product|Error {
    string path = PRODUCT_API_PATH + JSON;
    http:Request request = new;

    json newProductJson = <json>json.constructFrom(product);
    newProductJson = convertRecordKeysToJsonKeys(newProductJson);
    json payload = {
        product: newProductJson
    };

    request.setJsonPayload(<@untainted>payload);
    http:Response response = check getResponseForPostCall(productClient.getStore(), path, request);
    json responsePayload = check getJsonPayload(response);
    json productJson = <json>responsePayload.product;
    return getProductFromJson(productJson);
}

function updateProduct(ProductClient productClient, Product product, int id) returns @tainted Product|Error {
    string path = PRODUCT_API_PATH + "/" + id.toString() + JSON;
    json productJson = <json>json.constructFrom(product);
    productJson = convertRecordKeysToJsonKeys(productJson);
    json payload = {
        product: productJson
    };
    http:Request request = new;
    request.setJsonPayload(<@untainted>payload);
    http:Response response = check getResponseForPutCall(productClient.getStore(), path, request);

    json responsePayload = check getJsonPayload(response);
    json updatedProductJson = <json>responsePayload.product;
    return getProductFromJson(updatedProductJson);
}

function deleteProduct(ProductClient productClient, int id) returns Error? {
    string path = PRODUCT_API_PATH + "/" + id.toString() + JSON;
    _ = check getResponseForDeleteCall(productClient.getStore(), path);
}


function getProductFromJson(json jsonValue) returns Product|Error {
    map<json> productJson = <map<json>>convertJsonKeysToRecordKeys(jsonValue);
    string? createdAtString = getValueFromJson(CREATED_AT, productJson);
    string? updatedAtString = getValueFromJson(UPDATED_AT, productJson);
    string? publishedAtString = getValueFromJson(PUBLISHED_AT, productJson);
    json[]? variantsJsonArray = getJsonArrayFromJson(VARIANTS, productJson);
    json[]? imagesJsonArray = getJsonArrayFromJson(IMAGES, productJson);

    ProductVariant[]? variants = ();
    if (variantsJsonArray is json[]) {
        ProductVariant[] variantArray = [];
        foreach json value in variantsJsonArray {
            ProductVariant variant = check getVariantFromJson(value);
            variantArray.push(variant);
        }
        variants = variantArray;
    }

    Image[]? images = ();
    if (productJson.hasKey(IMAGE) && imagesJsonArray is json[]) {
        Image[] imageArray = [];
        foreach json value in imagesJsonArray {
            if (value is map<json>) {
                Image image = check getImageFromJson(value);
                imageArray.push(image);
            }
        }
        images = imageArray;
    }

    Image? image = ();
    if (productJson.hasKey(IMAGE) && productJson[IMAGE] is map<json>) {
        json imageJson = productJson.remove(IMAGE);
        image = check getImageFromJson(imageJson);
    }

    time:Time? createdAt = check getTimeRecordFromTimeString(createdAtString);
    time:Time? updatedAt = check getTimeRecordFromTimeString(updatedAtString);
    time:Time? publishedAt = check getTimeRecordFromTimeString(publishedAtString);

    var productFromJson = Product.constructFrom(productJson);

    if (productFromJson is error) {
        return createError("Error occurred while constructing the Product record.", productFromJson);
    }
    Product product = <Product>productFromJson;

    if (image is Image) {
        product.image = image;
    }
    if (variants is ProductVariant[]) {
        product.variants = variants;
    }
    if (images is Image[]) {
        product.images = images;
    }
    if (createdAt is time:Time) {
        product.createdAt = createdAt;
    }
    if (updatedAt is time:Time) {
        product.updatedAt = updatedAt;
    }
    if (publishedAt is time:Time) {
        product.publishedAt = publishedAt;
    }
    return product;
}

function getVariantFromJson(json value) returns ProductVariant|Error {
    map<json> variantJson = <map<json>>convertJsonKeysToRecordKeys(value);
    string? createdAtString = getValueFromJson(CREATED_AT, variantJson);
    string? updatedAtString = getValueFromJson(UPDATED_AT, variantJson);

    time:Time? createdAt = check getTimeRecordFromTimeString(createdAtString);
    time:Time? updatedAt = check getTimeRecordFromTimeString(updatedAtString);

    ProductVariant|error variantFromJson = ProductVariant.constructFrom(variantJson);
    if (variantFromJson is error) {
        return createError("Error occurred while constructing the Variant record.", variantFromJson);
    }
    ProductVariant variant = <ProductVariant>variantFromJson;
    if (createdAt is time:Time) {
        variant.createdAt = createdAt;
    }
    if (updatedAt is time:Time) {
        variant.updatedAt = updatedAt;
    }
    return variant;
}

function getImageFromJson(json value) returns Image|Error {
    map<json> imageJson = <map<json>>convertJsonKeysToRecordKeys(value);
    string? createdAtString = getValueFromJson(CREATED_AT, imageJson);
    string? updatedAtString = getValueFromJson(UPDATED_AT, imageJson);

    time:Time? createdAt = check getTimeRecordFromTimeString(createdAtString);
    time:Time? updatedAt = check getTimeRecordFromTimeString(updatedAtString);

    Image|error imageFromJson = Image.constructFrom(imageJson);
    if (imageFromJson is error) {
        return createError("Error occurred while constructing the Image record.", imageFromJson);
    }
    Image image = <Image>imageFromJson;
    if (createdAt is time:Time) {
        image.createdAt = createdAt;
    }
    if (updatedAt is time:Time) {
        image.updatedAt = updatedAt;
    }
    return image;
}

function getProductsFromPath(ProductClient productClient, string path) returns @tainted [Product[], string?]|Error {
    http:Response response = check getResponseForGetCall(productClient.getStore(), path);
    string? link = check getLinkFromHeader(response);

    json payload = check getJsonPayload(response);
    json[] productsJson = <json[]>payload.products;
    Product[] products = [];
    int i = 0;
    foreach var productJson in productsJson {
        var product = getProductFromJson(productJson);
        if (product is Error) {
            return product;
        } else {
            products[i] = product;
            i += 1;
        }
    }
    return [products, link];
}

type ProductStream object {
    string? link;
    ProductClient productClient;

    public function __init(string? link, ProductClient productClient) {
        self.link = link;
        self.productClient = productClient;
    }

    public function next() returns @tainted record {|Product[]|Error value;|}|Error? {
        if (self.link is ()) {
            return;
        }
        string linkString = <string>self.link;
        var result = getProductsFromPath(self.productClient, linkString);
        if (result is Error) {
            return {value: result};
        } else {
            var [products, link] = result;
            self.link = link;
            return {value: products};
        }
    }
};
