import ballerina/auth;
import ballerina/http;
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

function getRequestWithBasicAuth(Store store) returns http:Request {
    return new http:Request();
}

function getRequestWithOAuth(Store store) returns http:Request {
    http:Request request = new;
    request.addHeader(OAUTH_HEADER_KEY, store.accessToken);
    return request;
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

function checkResponse(http:Response response) returns Error? {
    int statusCode = response.statusCode;
    if (statusCode == http:STATUS_OK) {
        return;
    } else {
        var payload = response.getJsonPayload();
        if (payload is json) {
            map<json> payloadMap = <@untainted map<json>>payload;
            return createError(payloadMap[ERRORS_FIELD].toString());
        }
        return createError("Invalid response received.");
    }
}

function convertJsonKeysToRecordKeys(json jsonValue) returns json {
    if (jsonValue is json[]) {
        json[] resultJsonArray = [];
        foreach json value in jsonValue {
            resultJsonArray.push(convertJsonKeysToRecordKeys(value));
        }
        return resultJsonArray;
    } else if (jsonValue is map<json>) {
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
    } else {
        return jsonValue;
    }
}

function convertJsonKeyToRecordKey(string key, json value) returns json {
    string newKey = convertToCamelCase(key);
    json result = {
        newKey: value
    };
    return result;
}

function convertToUnderscoreCase(string value) returns string {
    string result = stringutils:replaceAll(value, "[A-Z]", "_$0");
    return result.toLowerAscii();
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

function getTimeRecordFromTimeString(string time) returns time:Time|Error {
    var parsedTime = time:parse(time, "yyyy-MM-dd'T'HH:mm:ssz");
    if (parsedTime is time:Error) {
        return createError("Error occurred while converting the time string", parsedTime);
    } else {
        return parsedTime;
    }
}

function getValueFromJson(string key, map<json> jsonMap) returns string {
    var result = trap jsonMap.remove(key);
    if (result is error) {
        return "";
    }
    return result.toString();
}

function notImplemented() returns Error {
    return error(ERROR_REASON, message = message);
}
