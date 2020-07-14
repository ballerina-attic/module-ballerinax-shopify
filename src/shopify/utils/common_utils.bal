import ballerina/auth;
import ballerina/encoding;
import ballerina/http;
import ballerina/io;
import ballerina/lang.'float;
import ballerina/lang.'int;
import ballerina/lang.'string;
import ballerina/stringutils;
import ballerina/time;

string message = "Not implemented";

function createHttpClient(string url) returns http:Client {
    http:Client httpClient = new (url);
    return httpClient;
}

function getAuthHandler(BasicAuthConfiguration config) returns http:BasicAuthHandler {
    auth:OutboundBasicAuthProvider outboundBasicAuthProvider = new ({
        username: config.username,
        password: config.password
    });
    return new (outboundBasicAuthProvider);
}

function createError(string message, error? e = ()) returns Error {
    Error shopifyError;
    if (e is error) {
        shopifyError = error(ERROR_REASON, message = message, cause = e);
    } else {
        shopifyError = error(ERROR_REASON, message = message);
    }
    return shopifyError;
}

function creatRecordArrayFromJsonArray(map<json> jsonValue, string 'field) returns json[] {
    if (jsonValue['field] is json[]) {
        return <json[]>jsonValue['field];
    } else {
        return [null];
    }
}

function checkResponse(http:Response response) returns http:Response|Error {
    int statusCode = response.statusCode;
    if (statusCode == http:STATUS_OK || statusCode == http:STATUS_CREATED || statusCode == http:STATUS_ACCEPTED) {
        return response;
    } else {
        var payload = response.getJsonPayload();
        if (payload is json) {
            Detail detail = {
                message: "Error response received from Shopify server."
            };
            detail.statusCode = statusCode;
            map<json> payloadMap = <@untainted map<json>>payload;
            string errorMessage = "";
            var errorRecord = payloadMap[ERRORS_FIELD];
            if (errorRecord is map<json>) {
                var additionalErrorInfo = AdditionalErrorInfo.constructFrom(errorRecord);
                if (additionalErrorInfo is AdditionalErrorInfo) {
                    detail.additionalErrorInfo = additionalErrorInfo;
                } else {
                    errorMessage = createErrorMessageFromJson(<map<json>>errorRecord);
                }
            } else {
                errorMessage = errorRecord.toString();
            }
            return createError(errorMessage);
        }
        return createError("Invalid response received.");
    }
}

function createErrorMessageFromJson(map<json> jsonMap) returns string {
    string result = "";
    foreach string key in jsonMap.keys() {
        result += key + " " + jsonMap[key].toString() + "; ";
    }
    return result;
}

function convertJsonKeysToRecordKeys(json jsonValue) returns json {
    if (jsonValue is json[]) {
        json[] resultJsonArray = [];
        foreach json value in jsonValue {
            resultJsonArray.push(convertJsonKeysToRecordKeys(value));
        }
        return resultJsonArray;
    }
    if (jsonValue is map<json>) {
        map<json> resultJson = {};
        foreach string key in jsonValue.keys() {
            string newKey = convertToCamelCase(key);
            json value = jsonValue[key];
            if (value is json[]) {
                resultJson[newKey] = convertJsonKeysToRecordKeys(value);
            } else {
                resultJson[newKey] = convertJsonKeysToRecordKeys(jsonValue[key]);
            }
        }
        return resultJson;
    }
    return jsonValue;
}

function convertToCamelCase(string key) returns string {
    string recordKey = "";
    string[] words = stringutils:split(key, "_");

    int i = 0;
    foreach string word in words {
        if (i == 0) {
            recordKey = word;
        } else {
            recordKey = recordKey + word.substring(0, 1).toUpperAscii() + word.substring(1, word.length());
        }
        i += 1;
    }
    return recordKey;
}

function convertRecordKeysToJsonKeys(json jsonValue) returns json {
    if (jsonValue is json[]) {
        json[] resultJsonArray = [];
        foreach json value in jsonValue {
            resultJsonArray.push(convertRecordKeysToJsonKeys(value));
        }
        return resultJsonArray;
    }
    if (jsonValue is map<json>) {
        map<json> resultJson = {};
        foreach string key in jsonValue.keys() {
            string newKey = convertToUnderscoreCase(key);
            json value = jsonValue[key];
            if (value is json[]) {
                resultJson[newKey] = convertRecordKeysToJsonKeys(value);
            } else {
                resultJson[newKey] = convertRecordKeysToJsonKeys(jsonValue[key]);
            }
        }
        return resultJson;
    }
    return jsonValue;
}

function convertToUnderscoreCase(string value) returns string {
    string result = stringutils:replaceAll(value, "[A-Z]", "_$0");
    return result.toLowerAscii();
}

function getTimeRecordFromTimeString(string? time) returns time:Time|Error? {
    if (time is () || time == "") {
        return;
    } else {
        var parsedTime = time:parse(time, DATE_FORMAT);
        if (parsedTime is time:Error) {
            return createError("Error occurred while converting the time string", parsedTime);
        } else {
            return parsedTime;
        }
    }
}

function getTimeStringTimeFromFilter(DateFilter filter, string filterType) returns string? {
    time:Time? date = filter[filterType];
    if (date is time:Time) {
        return getTimeStringFromTimeRecord(date);
    }
}

function getTimeStringFromTimeRecord(time:Time time) returns string {
    return time:toString(time);
}

function getValueFromJson(string key, map<json> jsonMap) returns string? {
    if (jsonMap.hasKey(key)) {
        var result = jsonMap.remove(key);
        return result.toString();
    }
}

function getFloatValueFromJson(string key, map<json> jsonMap) returns float|Error? {
    string errorMessage = "Error occurred while converting to the float value.";
    if (jsonMap.hasKey(key)) {
        var jsonValue = jsonMap.remove(key);
        var result = 'float:fromString(jsonValue.toString());
        if (result is error) {
            return createError(errorMessage, result);
        }
        return <float>result;
    }
}

function getIntValueFromJson(string key, map<json> jsonMap) returns int|Error {
    string errorMessage = "Error occurred while converting to the float value.";
    var jsonValue = jsonMap.remove(key);
    if (jsonValue is ()) {
        return createError(errorMessage + " Field " + key + " does not exist.", jsonValue);
    }
    var result = 'int:fromString(jsonValue.toString());
    if (result is error) {
        return createError(errorMessage, result);
    }
    return <int>result;
}

function getJsonArrayFromJson(string key, map<json> jsonMap) returns json[]? {
    if (jsonMap.hasKey(key)) {
        var result = jsonMap.remove(key);
        if (result is json[]) {
            return result;
        }
    }
    return;
}

function getJsonMapFromJson(string key, map<json> jsonMap) returns map<json>? {
    if (jsonMap.hasKey(key)) {
        var result = jsonMap.remove(key);
        if (result is map<json>) {
            return result;
        }
    }
}

function getJsonPayload(http:Response response) returns @tainted json|Error {
    json|error payload = response.getJsonPayload();
    if (payload is error) {
        return createError("Invalid payload received", payload);
    } else {
        return payload;
    }
}

function buildCommaSeparatedListFromArray(any[] array) returns string {
    string result = "";
    int i = 0;
    foreach var item in array {
        if (i == 0) {
            result += convertToUnderscoreCase(item.toString());
        } else {
            result += "," + convertToUnderscoreCase(item.toString());
        }
        i += 1;
    }
    return result;
}

function buildFieldsCommaSeparatedList(string[] array) returns string {
    string result = "";
    int i = 0;
    foreach string item in array {
        string fieldName = convertToUnderscoreCase(item);
        if (i == 0) {
            result += fieldName;
        } else {
            result += "," + fieldName;
        }
        i += 1;
    }
    return result;
}

function getLinkFromHeader(http:Response response) returns string|Error? {
    if (!response.hasHeader(LINK_HEADER)) {
        return;
    }

    string? link = check retrieveLinkHeaderValues(response.getHeader(LINK_HEADER));
    if (link is ()) {
        return link;
    }
    string linkString = <string>link;
    var result = encoding:decodeUriComponent(linkString, UTF8);
    if (result is error) {
        return createError("Error occurred while retaining the link to the next page.", result);
    } else {
        return stringutils:split(result, API_PATH)[1];
    }
}

// Ignore the "previous" value since we do not use it here, because stream does not allow to access more than once
function retrieveLinkHeaderValues(string linkHeaderValue) returns string|Error? {
    string[] pages = stringutils:split(linkHeaderValue, ",");
    foreach string page in pages {
        string link = stringutils:replaceAll(stringutils:split(page, ">")[0], " ", "");
        link = link.substring(1, link.length());
        string pageName = stringutils:split(page, "rel=")[1];
        pageName = stringutils:replaceAll(pageName, "\"", "");
        if (pageName == "next") {
            return link;
        }
    }
}

function getResponseForGetCall(Store store, string path) returns http:Response|Error {
    http:Client httpClient = store.getHttpClient();
    http:Request request = new;
    var result = httpClient->get(path, request);
    if (result is error) {
        return createError("Could not retrive data from the Shopify server.", result);
    }
    http:Response response = <http:Response>result;
    return checkResponse(response);
}

function getResponseForDeleteCall(Store store, string path) returns http:Response|Error {
    http:Client httpClient = store.getHttpClient();
    http:Request request = new;
    var result = httpClient->delete(path, request);
    if (result is error) {
        return createError("Could not retrive data from the Shopify server.", result);
    }
    http:Response response = <http:Response>result;
    return checkResponse(response);
}

function getResponseForPostCall(Store store, string path, http:Request request) returns http:Response|Error {
    http:Client httpClient = store.getHttpClient();
    var result = httpClient->post(path, request);
    if (result is error) {
        return createError("Could not retrive data from the Shopify server.", result);
    }
    http:Response response = <http:Response>result;
    return checkResponse(response);
}

function getResponseForPutCall(Store store, string path, http:Request request) returns http:Response|Error {
    http:Client httpClient = store.getHttpClient();
    var result = httpClient->put(path, request);
    if (result is error) {
        return createError("Could not retrive data from the Shopify server.", result);
    }
    http:Response response = <http:Response>result;
    return checkResponse(response);
}

function notImplemented() returns Error {
    io:println("Not implemented");
    return error(ERROR_REASON, message = message);
}

function buildQueryParamtersFromFilter(Filter filter) returns string|Error {
    string queryParams = "";
    foreach var [key, value] in filter.entries() {
        if (key == LIMIT && filter?.'limit is int) {
            int 'limit = <int>filter?.'limit;
            if ('limit < 1 || 'limit > PAGE_MAX_LIMIT) {
                return createError("The max limit must be a positive integer less than " + PAGE_MAX_LIMIT.toString()
                    + " (inclusive)");
            }
            queryParams += "&" + LIMIT + "=" + 'limit.toString();
        } else if (filter[key] is int || filter[key] is string) {
            queryParams += "&" + convertToUnderscoreCase(key) + "=" + filter[key].toString();
        } else if (filter[key] is int[] || filter[key] is string[]) {
            queryParams += "&" + convertToUnderscoreCase(key) + "=" + buildCommaSeparatedListFromArray(<any[]>filter[key]);
        } else if (filter[key] is DateFilter) {
            DateFilter dateFilter = <DateFilter>filter[key];
            string? before = getTimeStringTimeFromFilter(dateFilter, BEFORE);
            if (before is string) {
                queryParams += "&" + convertToUnderscoreCase(key) + SUFFIX_MAX + "=" + before;
            }
            string? after = getTimeStringTimeFromFilter(dateFilter, AFTER);
            if (after is string) {
                queryParams += "&" + convertToUnderscoreCase(key) + SUFFIX_MIN + "=" + after;
            }
        }
    }
    if (queryParams == "") {
        return queryParams;
    } else {
        // Remove starting '&' character from the query parameters
        return "?" + 'string:substring(queryParams, 1, queryParams.length());
    }
}
