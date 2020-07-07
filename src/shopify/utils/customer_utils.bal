import ballerina/http;
import ballerina/lang.'string;
import ballerina/time;

function getAllCustomers(CustomerClient customerClient, CustomerFilter? filter) returns @tainted stream<Customer[]>|Error {
    string queryParams = "";
    if (filter is CustomerFilter) {
        var result = trap buildQueryParamtersFromCustomerFilter(filter);
        if (result is Error) {
            return result;
        }
        queryParams = <string>result;
    }
    string path = CUSTOMER_API_PATH + JSON + queryParams;

    CustomerStream customerStream = new (path, customerClient);
    return new stream <Customer[]|Error, Error>(customerStream);
}

function getCustomer(CustomerClient customerClient, int id, string[]? fields) returns @tainted Customer|Error {
    string path = CUSTOMER_API_PATH + "/" + id.toString() + JSON;
    http:Response response = check getResponseForGetCall(customerClient.getStore(), path);
    json payload = check getJsonPayload(response);
    json customerJson = <json>payload.customer;
    return getCustomerFromJson(customerJson);
}

function createCustomer(CustomerClient customerClient, NewCustomer customer) returns @tainted Customer|Error {
    string path = CUSTOMER_API_PATH + JSON;
    http:Request request = customerClient.getStore().getRequest();

    json newCustomerJson = <json>json.constructFrom(customer);
    newCustomerJson = convertRecordKeysToJsonKeys(newCustomerJson);
    json payload = {
        customer: newCustomerJson
    };
    request.setJsonPayload(<@untainted>payload);
    http:Response response = check getResponseForPostCall(customerClient.getStore(), path, request);

    json responsePayload = check getJsonPayload(response);
    json customerJson = <json>responsePayload.customer;
    return getCustomerFromJson(customerJson);
}

function updateCustomer(CustomerClient customerClient, Customer customer, int id) returns @tainted Customer|Error {
    string path = CUSTOMER_API_PATH + "/" + id.toString() + JSON;
    json customerJson = <json>json.constructFrom(customer);
    customerJson = convertRecordKeysToJsonKeys(customerJson);
    json payload = {
        customer: customerJson
    };
    http:Request request = customerClient.getStore().getRequest();
    request.setJsonPayload(<@untainted>payload);
    http:Response response = check getResponseForPutCall(customerClient.getStore(), path, request);

    json responsePayload = check getJsonPayload(response);
    json updatedCustomerJson = <json>responsePayload.customer;
    return getCustomerFromJson(updatedCustomerJson);
}

function removeCustomer(CustomerClient customerClient, int id) returns Error? {
    string path = CUSTOMER_API_PATH + "/" + id.toString() + JSON;
    http:Response response = check getResponseForDeleteCall(customerClient.getStore(), path);
}

function getCustomerCount(CustomerClient customerClient) returns @tainted int|Error {
    string path = CUSTOMER_API_PATH + COUNT_PATH + JSON;
    http:Response response = check getResponseForGetCall(customerClient.getStore(), path);

    json payload = check getJsonPayload(response);
    map<json> jsonMap = <map<json>>payload;
    return getIntValueFromJson(COUNT, jsonMap);
}

function getCustomerOrders(int id) returns Order[]|Error {
    return notImplemented();
}

function getCustomerActivationUrl(CustomerClient customerClient, int id) returns @tainted string|Error {
    string path = CUSTOMER_API_PATH + "/" + id.toString() + "/" + ACTIVATION_URL + JSON;
    http:Response response = check getResponseForGetCall(customerClient.getStore(), path);

    map<json> responsePayload = <map<json>>check getJsonPayload(response);
    var activationUrl = trap responsePayload[ACTIVATION_URL].toString();
    if (activationUrl is error) {
        return createError("Error occurred while retriving the activation URL.", activationUrl);
    } else {
        return activationUrl;
    }
}

function sendCustomerInvitation(int id, Invite invite) returns Invite|Error {
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
        return createError("Error occurred while constructing the Customer record.", customerFromJson);
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

function buildQueryParamtersFromCustomerFilter(CustomerFilter filter) returns string {
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
        } else if (key == LIMIT && filter?.'limit is int) {
            int 'limit = <int>filter?.'limit;
            if ('limit <1 || 'limit > PAGE_MAX_LIMIT) {
                panic createError("The max limit must be a positive integer less than " + PAGE_MAX_LIMIT.toString() +
                    " (inclusive)");
            }
            string limitString = (filter?.'limit).toString();
            queryParams += "&" + LIMIT + "=" + limitString;
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

function getCustomersFromPath(CustomerClient customerClient, string path) returns @tainted [Customer[], string?]|Error {
    http:Response response = check getResponseForGetCall(customerClient.getStore(), path);
    string? link = check getLinkFromHeader(response);

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
    return [customers, link];
}

type CustomerStream object {
    string? link;
    CustomerClient customerClient;

    public function __init(string? link, CustomerClient customerClient) {
        self.link = link;
        self.customerClient = customerClient;
    }

    public function next() returns @tainted record {|Customer[]|Error value;|}|Error? {
        if (self.link is ()) {
            return;
        }
        string linkString = <string>self.link;
        var result = getCustomersFromPath(self.customerClient, linkString);
        if (result is Error) {
            return {value: result};
        } else {
            var [customers, link] = result;
            self.link = link;
            return {value: customers};
        }
    }
};
