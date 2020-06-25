import ballerina/http;
import ballerina/time;

// TODO: Handle pagination
function getAllCustomers(CustomerClient customerClient, CustomerFilter? filter) returns @tainted Customer[]|Error {
    string queryParams = "";
    if (filter is CustomerFilter) {
        queryParams = "?";
        foreach var [key, value] in filter.entries() {
            if (key == ID && filter?.ids is int[]) {
                queryParams += "ids=";
                int[] ids = <int[]>filter?.ids;
                int i = 0;
                foreach int id in ids {
                    if (i == 0) {
                        queryParams += id.toString();
                    } else {
                        queryParams += "," + id.toString();
                    }
                    i += 1;
                }
            } else if (key == SINCE_ID) {
                queryParams += convertToUnderscoreCase(key) + "=" + filter?.sinceId.toString();
            }
        }
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
        var customer = getCustomerFromJson(<@untainted>customerJson);
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
    string createdAtString = getValueFromJson(CREATED_AT, customerJson);
    string updatedAtString = customerJson.remove(UPDATED_AT).toString();
    string marketingUpdatedAtString = customerJson.remove(MARKETING_UPDATED_AT).toString();

    time:Time createdAt = check getTimeRecordFromTimeString(createdAtString);
    time:Time updatedAt = check getTimeRecordFromTimeString(updatedAtString);
    time:Time marketingUpdatedAt = check getTimeRecordFromTimeString(marketingUpdatedAtString);
    float totalSpending = check getFloatValueFromJson(TOTAL_SPENT, customerJson);

    var customerFromJson = Customer.constructFrom(customerJson);

    if (customerFromJson is error) {
        return createError("Error occurred while constructiong the Customer record.", customerFromJson);
    }
    Customer customer = <Customer>customerFromJson;
    customer.createdAt = createdAt;
    customer.updatedAt = updatedAt;
    customer.acceptsMarketingUpdatedAt = marketingUpdatedAt;
    customer.totalSpent = totalSpending;
    return customer;
}
