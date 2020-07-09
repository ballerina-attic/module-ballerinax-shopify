import ballerina/http;
import ballerina/time;

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
        queryParams = "?" + FIELDS + "=" + buildCommaSeparatedListFromArray(fields);
    }
    string path = CUSTOMER_API_PATH + "/" + id.toString() + JSON + queryParams;
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
