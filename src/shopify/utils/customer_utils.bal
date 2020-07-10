import ballerina/http;
import ballerina/time;
import ballerina/io;

function getAllCustomers(CustomerClient customerClient, CustomerFilter? filter) returns @tainted stream<Customer[]>|Error {
    string queryParams = "";
    if (filter is CustomerFilter) {
        queryParams = check buildQueryParamtersFromFilter(filter);
    }
    string path = CUSTOMER_API_PATH + JSON + queryParams;

    CustomerStream customerStream = new (path, customerClient);
    return new stream <Customer[]|Error, Error>(customerStream);
}

function getCustomer(CustomerClient customerClient, int id, string[]? fields) returns @tainted Customer|Error {
    string queryParams = "";
    if (fields is string[]) {
        // We don't need to validate these fields since the Shopify server will validate them
        queryParams = "?" + FIELDS + "=" + buildCommaSeparatedListFromArray(fields);
    }
    string path = CUSTOMER_API_PATH + "/" + id.toString() + JSON + queryParams;
    http:Response response = check getResponseForGetCall(customerClient.getStore(), path);
    json payload = check getJsonPayload(response);
    json customerJson = <json>payload.customer;
    return getCustomerFromJson(customerJson);
}

function searchCustomers(CustomerClient customerClient, string query, CustomerSearchFilter? filter) returns
    @tainted stream<Customer[]>|Error {
    string queryParams = "?" + QUERY + "=" + query;
    if (filter is CustomerSearchFilter) {
        foreach string key in filter.keys() {
            if (key == LIMIT && filter[key] is int) {
                queryParams += "&" + convertToUnderscoreCase(key) + "=" + filter[key].toString();
            } else if (key == FIELDS && filter[key] is string[]) {
                queryParams += "&" + convertToUnderscoreCase(key) + "="
                    + buildCommaSeparatedListFromArray(<string[]>filter[key]);
            } else if (key == ORDER_BY && filter[key] is string) {
                queryParams += "&" + ORDER + "=" + convertToUnderscoreCase(filter[key].toString());
                if (filter.decending) {
                    queryParams += " " + DESC;
                } else {
                    queryParams += " " + ASC;
                }
            }
        }
    }
    string path = CUSTOMER_API_PATH + SEARCH_PATH + JSON + queryParams;
    io:println(path);
    CustomerStream customerStream = new (path, customerClient);
    return new stream <Customer[]|Error, Error>(customerStream);
}

function createCustomer(CustomerClient customerClient, NewCustomer customer) returns @tainted Customer|Error {
    string path = CUSTOMER_API_PATH + JSON;

    http:Request request = new;
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
    http:Request request = new;
    request.setJsonPayload(<@untainted>payload);
    http:Response response = check getResponseForPutCall(customerClient.getStore(), path, request);

    json responsePayload = check getJsonPayload(response);
    json updatedCustomerJson = <json>responsePayload.customer;
    return getCustomerFromJson(updatedCustomerJson);
}

function removeCustomer(CustomerClient customerClient, int id) returns Error? {
    string path = CUSTOMER_API_PATH + "/" + id.toString() + JSON;
    _ = check getResponseForDeleteCall(customerClient.getStore(), path);
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
    return customer;
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
