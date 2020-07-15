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

function getAllCustomers(CustomerClient customerClient, CustomerFilter? filter) returns
    @tainted stream<Customer[]>|Error {
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
    CustomerStream customerStream = new (path, customerClient);
    return new stream <Customer[]|Error, Error>(customerStream);
}

function createCustomer(CustomerClient customerClient, NewCustomer customer) returns @tainted Customer|Error {
    string path = CUSTOMER_API_PATH + JSON;

    http:Request request = new;
    json newCustomerJson = <json>customer.cloneWithType(json);
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

    json customerJson = <json>customer.cloneWithType(json);
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

function getCustomerOrders(CustomerClient customerClient, int id) returns @tainted Order[]|Error {
    string path = CUSTOMER_API_PATH + "/" + id.toString() + ORDER_API_PATH + JSON;
    http:Response response = check getResponseForGetCall(customerClient.getStore(), path);

    json payload = check getJsonPayload(response);
    json[] ordersJsonArray = <json[]>payload.orders;
    Order[] orders = [];
    foreach var orderJson in ordersJsonArray {
        Order order = check getOrderFromJson(orderJson);
        orders.push(order);
    }
    return orders;
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

function sendCustomerInvitation(CustomerClient customerClient, int id, Invite invite) returns @tainted Invite|Error {
    string path = CUSTOMER_API_PATH + "/" + id.toString() + SEND_INVITE_PATH + JSON;
    json invitationJson = <json>invite.cloneWithType(json);
    invitationJson = convertRecordKeysToJsonKeys(invitationJson);
    json payload = {
        customer: invitationJson
    };
    http:Request request = new;
    request.setJsonPayload(<@untainted>payload);
    http:Response response = check getResponseForPostCall(customerClient.getStore(), path, request);

    map<json> responsePayload = <map<json>>check getJsonPayload(response);
    json resultingInviteJson = <json>responsePayload.customer_invite;
    var resultingInvite = resultingInviteJson.cloneWithType(Invite);
    if (resultingInvite is error) {
        return createError("Error occurred while constructing the Invite record.", resultingInvite);
    }
    return <Invite>resultingInvite;
}

function getCustomerFromJson(json jsonValue) returns Customer|Error {
    map<json> customerJson = <map<json>>convertJsonKeysToRecordKeys(jsonValue);
    string? createdAtString = getValueFromJson(CREATED_AT, customerJson);
    string? updatedAtString = getValueFromJson(UPDATED_AT, customerJson);
    string? marketingUpdatedAtString = getValueFromJson(MARKETING_UPDATED_AT, customerJson);

    time:Time? createdAt = check getTimeRecordFromTimeString(createdAtString);
    time:Time? updatedAt = check getTimeRecordFromTimeString(updatedAtString);
    time:Time? marketingUpdatedAt = check getTimeRecordFromTimeString(marketingUpdatedAtString);

    var customerFromJson = customerJson.cloneWithType(Customer);

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

    public function init(string? link, CustomerClient customerClient) {
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
