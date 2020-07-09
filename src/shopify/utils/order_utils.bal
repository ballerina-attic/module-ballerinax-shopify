import ballerina/http;
import ballerina/time;

function getAllOrders(OrderClient orderClient, OrderFilter? filter) returns @tainted stream<Order[]>|Error {
    string queryParams = "";
    if (filter is OrderFilter) {
        queryParams = check buildQueryParamtersFromFilter(filter);
    }
    string path = ORDER_API_PATH + JSON + queryParams;

    OrderStream orderStream = new (path, orderClient);
    return new stream <Order[]|Error, Error>(orderStream);
}

function getOrder(OrderClient orderClient, int id, string[]? fields) returns @tainted Order|Error {
    string queryParams = "";
    if (fields is string[]) {
        queryParams = "?" + FIELDS + "=" + buildCommaSeparatedListFromArray(fields);
    }
    string path = ORDER_API_PATH + "/" + id.toString() + JSON + queryParams;
    http:Response response = check getResponseForGetCall(orderClient.getStore(), path);
    json payload = check getJsonPayload(response);
    json orderJson = <json>payload.order;
    return getOrderFromJson(orderJson);
}

function getOrderCount(OrderClient orderClient, OrderCountFilter? filter) returns @tainted int|Error {
    string queryParams = "";
    if (filter is OrderFilter) {
        queryParams = check buildQueryParamtersFromFilter(filter);
    }
    string path = ORDER_API_PATH + COUNT_PATH + JSON + queryParams;
    http:Response response = check getResponseForGetCall(orderClient.getStore(), path);

    json payload = check getJsonPayload(response);
    map<json> jsonMap = <map<json>>payload;
    return getIntValueFromJson(COUNT, jsonMap);
}

function closeOrder(OrderClient orderClient, int id) returns @tainted Order|Error {
    string path = ORDER_API_PATH + "/" + id.toString() + CLOSE_PATH + JSON;
    http:Request request = orderClient.getStore().getRequest();
    http:Response response = check getResponseForPostCall(orderClient.getStore(), path, request);
    json payload = check getJsonPayload(response);
    json orderJson = <json>payload.order;
    return getOrderFromJson(orderJson);
}

function openOrder(OrderClient orderClient, int id) returns @tainted Order|Error {
    string path = ORDER_API_PATH + "/" + id.toString() + OPEN_PATH + JSON;
    http:Request request = orderClient.getStore().getRequest();
    http:Response response = check getResponseForPostCall(orderClient.getStore(), path, request);
    json payload = check getJsonPayload(response);
    json orderJson = <json>payload.order;
    return getOrderFromJson(orderJson);
}

function cancelOrder() returns Order|Error {
    return notImplemented();
}

function createOrder(OrderClient orderClient, NewOrder order) returns @tainted Order|Error {
    string path = ORDER_API_PATH + JSON;
    http:Request request = orderClient.getStore().getRequest();

    json newOrderJson = <json>json.constructFrom(order);
    newOrderJson = convertRecordKeysToJsonKeys(newOrderJson);
    json payload = {
        order: newOrderJson
    };

    request.setJsonPayload(<@untainted>payload);
    http:Response response = check getResponseForPostCall(orderClient.getStore(), path, request);
    json responsePayload = check getJsonPayload(response);
    json orderJson = <json>responsePayload.order;
    return getOrderFromJson(orderJson);
}

function updateOrder(OrderClient orderClient, Order order, int id) returns @tainted Order|Error {
    string path = ORDER_API_PATH + "/" + id.toString() + JSON;
    json orderJson = <json>json.constructFrom(order);
    orderJson = convertRecordKeysToJsonKeys(orderJson);
    json payload = {
        order: orderJson
    };
    http:Request request = orderClient.getStore().getRequest();
    request.setJsonPayload(<@untainted>payload);
    http:Response response = check getResponseForPutCall(orderClient.getStore(), path, request);

    json responsePayload = check getJsonPayload(response);
    json updatedOrderJson = <json>responsePayload.order;
    return getOrderFromJson(updatedOrderJson);
}

function deleteOrder(OrderClient orderClient, int id) returns Error? {
    string path = ORDER_API_PATH + "/" + id.toString() + JSON;
    _ = check getResponseForDeleteCall(orderClient.getStore(), path);

}

function getOrderFromJson(json jsonValue) returns Order|Error {
    map<json> orderJson = <map<json>>convertJsonKeysToRecordKeys(jsonValue);
    string? createdAtString = getValueFromJson(CREATED_AT, orderJson);
    string? updatedAtString = getValueFromJson(UPDATED_AT, orderJson);
    string? closedAtString = getValueFromJson(CLOSED_AT, orderJson);
    string? cancelledAtString = getValueFromJson(CANCELLED_AT, orderJson);
    string? processedAtString = getValueFromJson(PROCESSED_AT, orderJson);
    json[]? fulfillmentsJsonArray = getJsonArrayFromJson(FULFILLMENTS, orderJson);

    Fulfillment[]? fulfillments = ();
    if (fulfillmentsJsonArray is json[]) {
        Fulfillment[] fulfillmentArray = [];
        foreach json value in fulfillmentsJsonArray {
            Fulfillment fulfillment = check getFulfillmentFromJson(value);
            fulfillmentArray.push(fulfillment);
        }
        fulfillments = fulfillmentArray;
    }

    time:Time? createdAt = check getTimeRecordFromTimeString(createdAtString);
    time:Time? updatedAt = check getTimeRecordFromTimeString(updatedAtString);
    time:Time? closedAt = check getTimeRecordFromTimeString(closedAtString);
    time:Time? cancelledAt = check getTimeRecordFromTimeString(cancelledAtString);
    time:Time? processedAt = check getTimeRecordFromTimeString(processedAtString);

    map<json>? customerJson = getJsonMapFromJson(CUSTOMER, orderJson);
    Customer? customer = ();

    if (customerJson is map<json>) {
        customer = check getCustomerFromJson(customerJson);
    }

    Order|error orderFromJson = Order.constructFrom(orderJson);
    if (orderFromJson is error) {
        return createError("Error converting the json payload to Order record.", orderFromJson);
    }
    Order order = <Order>orderFromJson;

    if (fulfillments is Fulfillment[]) {
        order.fulfillments = fulfillments;
    }
    if (createdAt is time:Time) {
        order.createdAt = createdAt;
    }
    if (updatedAt is time:Time) {
        order.updatedAt = updatedAt;
    }
    if (closedAt is time:Time) {
        order.closedAt = closedAt;
    }
    if (cancelledAt is time:Time) {
        order.cancelledAt = cancelledAt;
    }
    if (processedAt is time:Time) {
        order.processedAt = processedAt;
    }
    if (customer is Customer) {
        order.customer = customer;
    }

    return order;
}

function getFulfillmentFromJson(json value) returns Fulfillment|Error {
    map<json> fulfillmentJson = <map<json>>convertJsonKeysToRecordKeys(value);
    string? createdAtString = getValueFromJson(CREATED_AT, fulfillmentJson);
    string? updatedAtString = getValueFromJson(UPDATED_AT, fulfillmentJson);

    time:Time? createdAt = check getTimeRecordFromTimeString(createdAtString);
    time:Time? updatedAt = check getTimeRecordFromTimeString(updatedAtString);

    Fulfillment|error fulfillmentFromJson = Fulfillment.constructFrom(fulfillmentJson);
    if (fulfillmentFromJson is error) {
        return createError("Error occurred while constructing the Fulfillment record.", fulfillmentFromJson);
    }
    Fulfillment fulfillment = <Fulfillment>fulfillmentFromJson;
    if (createdAt is time:Time) {
        fulfillment.createdAt = createdAt;
    }
    if (updatedAt is time:Time) {
        fulfillment.updatedAt = updatedAt;
    }
    return fulfillment;
}

function getOrdersFromPath(OrderClient orderClient, string path) returns @tainted [Order[], string?]|Error {
    http:Response response = check getResponseForGetCall(orderClient.getStore(), path);
    string? link = check getLinkFromHeader(response);

    json payload = check getJsonPayload(response);
    json[] ordersJson = <json[]>payload.orders;
    Order[] orders = [];
    int i = 0;
    foreach var orderJson in ordersJson {
        var order = getOrderFromJson(orderJson);
        if (order is Error) {
            return order;
        } else {
            orders[i] = order;
            i += 1;
        }
    }
    return [orders, link];
}

type OrderStream object {
    string? link;
    OrderClient orderClient;

    public function __init(string? link, OrderClient orderClient) {
        self.link = link;
        self.orderClient = orderClient;
    }

    public function next() returns @tainted record {|Order[]|Error value;|}|Error? {
        if (self.link is ()) {
            return;
        }
        string linkString = <string>self.link;
        var result = getOrdersFromPath(self.orderClient, linkString);
        if (result is Error) {
            return {value: result};
        } else {
            var [orders, link] = result;
            self.link = link;
            return {value: orders};
        }
    }
};
