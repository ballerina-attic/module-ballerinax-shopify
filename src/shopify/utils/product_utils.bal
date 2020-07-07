import ballerina/http;
import ballerina/time;

function getAllProducts(ProductFilter filter) returns Product[]|Error {

    return notImplemented();
}

function getProductCount() returns int {
    return 0;
}

function getProduct(ProductClient productClient, int id) returns @tainted Product|Error {
    string path = PRODUCT_API_PATH + "/" + id.toString() + JSON;
    http:Response response = check getResponseForGetCall(productClient.getStore(), path);
    json payload = check getJsonPayload(response);
    json productJson = <json>payload.product;
    return getProductFromJson(productJson);
}

function createProduct(ProductClient productClient, NewProduct product) returns @tainted Product|Error {
    string path = PRODUCT_API_PATH + JSON;
    http:Request request = productClient.getStore().getRequest();

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

function updateProduct() returns Product|Error {
    return notImplemented();
}

function deleteProduct(ProductClient productClient, int id) returns Error? {
    string path = PRODUCT_API_PATH + "/" + id.toString() + JSON;
    http:Response response = check getResponseForDeleteCall(productClient.getStore(), path);
}


function getProductFromJson(json jsonValue) returns Product|Error {
    map<json> productJson = <map<json>>convertJsonKeysToRecordKeys(jsonValue);
    string? createdAtString = getValueFromJson(CREATED_AT, productJson);
    string? updatedAtString = getValueFromJson(UPDATED_AT, productJson);
    string? publishedAtString = getValueFromJson(PUBLISHED_AT, productJson);
    json[] variantsJsonArray = getJsonArrayFromJson(productJson, VARIANTS);
    json[] imagesJsonArray = getJsonArrayFromJson(productJson, IMAGES);

    ProductVariant[] variants = [];
    foreach json value in variantsJsonArray {
        ProductVariant variant = check getVariantFromJson(value);
        variants.push(variant);
    }

    Image[] images = [];
    foreach json value in imagesJsonArray {
        Image? image = check getImageFromJson(value);
        if (image is Image) {
            images.push(image);
        }
    }

    Image? image = ();
    if (productJson.hasKey(IMAGE)) {
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
    product.variants = variants;
    if (createdAt is time:Time) {
        product.createdAt = createdAt;
    }
    if (updatedAt is time:Time) {
        product.updatedAt = updatedAt;
    }
    if (publishedAt is time:Time) {
        product.publishedAt = publishedAt;
    }
    product.image = image;
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

function getImageFromJson(json value) returns Image|Error? {
    if (value is ()) {
        return;
    }
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
