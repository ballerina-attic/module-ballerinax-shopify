import ballerina/http;
import ballerina/lang.'string;
import ballerina/time;

// TODO: Handle pagination
function getAllCustomers(CustomerClient customerClient, CustomerFilter? filter) returns @tainted Customer[]|Error {
    string queryParams = "";
    if (filter is CustomerFilter) {
        queryParams = buildQueryParamters(filter);
    }
    string path = CUSTOMER_API_PATH + JSON + queryParams;
    http:Client httpClient = customerClient.getStore().getHttpClient();
    http:Request request = customerClient.getStore().getRequest();
    var result = httpClient->get(path, request);
    if (result is error) {
        return createError("Could not retrive data from the Shopify server.", result);
    }
    http:Response response = <http:Response>result;

    // Check status code and return error if theres any
    check checkResponse(response);

    json payload = check getJsonPayload(response);
    json[] customersJson = <json[]>payload.customers;
    Customer[] customers = [];
    int i = 0;
    foreach var customerJson in customersJson {
        var customer = getCustomerFromJson(customerJson);
        if (customer is Error) {
            return customer;
        } else {
            customers[i] = customer;
            i += 1;
        }
    }
    return customers;
}

function getCustomer(int id, string[]? fields) returns Customer|Error {
    return notImplemented();
}

function createCustomer(Customer customer) returns Customer|Error {
    return notImplemented();
}

function updateCustomer(Customer customer) returns Customer|Error {
    return notImplemented();
}

function removeCustomer(Customer Customer) returns Error? {
    return notImplemented();
}

function getCustomerCount(CustomerClient customerClient) returns @tainted int|Error {
    string path = CUSTOMER_API_PATH + COUNT_PATH + JSON;
    http:Client httpClient = customerClient.getStore().getHttpClient();
    http:Request request = customerClient.getStore().getRequest();
    var result = httpClient->get(path, request);

    if (result is error) {
        return createError("Could not retrive data from the Shopify server.", result);
    }
    http:Response response = <http:Response>result;

    // Check status code and return error if theres any
    check checkResponse(response);

    json payload = check getJsonPayload(response);
    map<json> jsonMap = <map<json>>payload;
    return getIntValueFromJson(COUNT, jsonMap);
}

function getCustomerOrders(string id) returns Order[]|Error {
    return notImplemented();
}

function getCustomerActivationUrl(string id) returns string|Error {
    return notImplemented();
}

function sendCustomerInvitation(string id, Invite invite) returns Invite|Error {
    return notImplemented();
}

function getCustomerFromJson(json jsonValue) returns Customer|Error {
    map<json> customerJson = <map<json>>convertJsonKeysToRecordKeys(jsonValue);
    string? createdAtString = getValueFromJson(CREATED_AT, customerJson);
    string? updatedAtString = getValueFromJson(UPDATED_AT, customerJson);
    string? marketingUpdatedAtString = getValueFromJson(MARKETING_UPDATED_AT, customerJson);

    time:Time? createdAt = check getTimeRecordFromTimeString(createdAtString);
    time:Time? updatedAt = check getTimeRecordFromTimeString(updatedAtString);
    time:Time? marketingUpdatedAt = check getTimeRecordFromTimeString(marketingUpdatedAtString);
    float? totalSpending = check getFloatValueFromJson(TOTAL_SPENT, customerJson);

    var customerFromJson = Customer.constructFrom(customerJson);

    if (customerFromJson is error) {
        return createError("Error occurred while constructiong the Customer record.", customerFromJson);
    }
    Customer customer = <Customer>customerFromJson;
    if (createdAt is time:Time) {
        customer.createdAt = createdAt;
    }
    if (updatedAt is time:Time) {
        customer.updatedAt = updatedAt;
    }
    if (marketingUpdatedAt is time:Time) {
        customer.acceptsMarketingUpdatedAt = marketingUpdatedAt;
    }
    if (totalSpending is float) {
        customer.totalSpent = totalSpending;
    }
    return customer;
}

function buildQueryParamters(CustomerFilter filter) returns string {
    string queryParams = "";
    foreach var [key, value] in filter.entries() {
        if (key == IDS && filter?.ids is int[]) {
            int[] ids = <int[]>filter?.ids;
            queryParams += "&" + IDS + "=" + buildCommaSeparatedListFromArray(ids);
        } else if (key == SINCE_ID && filter?.sinceId is int) {
            queryParams += "&" + convertToUnderscoreCase(key) + "=" + filter?.sinceId.toString();
        } else if (key == CREATED_DATE_FILTER && filter?.createdDateFilter is DateFilter) {
            DateFilter dateFilter = <DateFilter>filter?.createdDateFilter;
            string? createdBefore = getTimeStringTimeFromFilter(dateFilter, BEFORE);
            if (createdBefore is string) {
                queryParams += "&" + UPDATED_BEFORE + "=" + createdBefore;
                string s = queryParams.toString();
            }
            string? createdAfter = getTimeStringTimeFromFilter(dateFilter, AFTER);
            if (createdAfter is string) {
                queryParams += "&" + UPDATED_AFTER + "=" + createdAfter;
            }
        } else if (key == UPDATED_DATE_FILTER && filter?.updatedDateFilter is DateFilter) {
            DateFilter dateFilter = <DateFilter>filter?.updatedDateFilter;
            string? createdBefore = getTimeStringTimeFromFilter(dateFilter, BEFORE);
            if (createdBefore is string) {
                queryParams += "&" + UPDATED_BEFORE + "=" + createdBefore;
            }
            string? createdAfter = getTimeStringTimeFromFilter(dateFilter, AFTER);
            if (createdAfter is string) {
                queryParams += "&" + UPDATED_AFTER + "=" + createdAfter;
            }
        } else if (key == FIELDS && filter?.fields is string[]) {
            string[] fields = <string[]>filter?.fields;
            queryParams += "&" + FIELDS + "=" + buildCommaSeparatedListFromArray(fields);
        }
    }
    if (queryParams == "") {
        return queryParams;
    } else {
        return "?" + 'string:substring(queryParams, 1, queryParams.length());
    }
}
