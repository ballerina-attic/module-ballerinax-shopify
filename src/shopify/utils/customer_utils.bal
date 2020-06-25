import ballerina/http;
import ballerina/time;

function getAllCustomers(CustomerClient customerClient, CustomerFilter? filter) returns @tainted Customer[]|Error {
    string path = CUSTOMER_API_PATH + JSON;
    http:Client httpClient = customerClient.getStore().getHttpClient();
    http:Request request = customerClient.getStore().getRequest();
    var result = httpClient->get(path, request);
    if (result is error) {
        return createError("Could not retrive data from the Shopify server.", result);
    }
    http:Response response = <http:Response>result;

    // Check status code and return error if theres any
    check checkResponse(response);

    var payload = response.getJsonPayload();
    if (payload is error) {
        return createError("Invalid payload received", payload);
    }

    json jsonPayload = <json>payload;
    json[] customersJson = <json[]> jsonPayload.customers;
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

function getCustomer(string id, string[]? fields) returns Customer|Error {
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

function getCustomerCount() returns int {
    return -999;
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
    string createdAtString = getValueFromJson(CREATED_AT, customerJson);
    string updatedAtString = customerJson.remove(UPDATED_AT).toString();
    string marketingUpdatedAtString = customerJson.remove(MARKETING_UPDATED_AT).toString();

    time:Time createdAt = check getTimeRecordFromTimeString(createdAtString);
    time:Time updatedAt = check getTimeRecordFromTimeString(updatedAtString);
    time:Time marketingUpdatedAt = check getTimeRecordFromTimeString(marketingUpdatedAtString);

    var customerFromJson = Customer.constructFrom(customerJson);

    if (customerFromJson is error) {
        return createError("Error occurred while constructiong the Customer record.", customerFromJson);
    }
    Customer customer = <Customer>customerFromJson;
    customer.createdAt = createdAt;
    customer.updatedAt = updatedAt;
    customer.acceptsMarketingUpdatedAt = marketingUpdatedAt;
    return customer;
}
