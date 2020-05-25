import ballerina/time;

public type OrderClient client object {

    # Retrieves all the orders placed in the store. This supports pagination.
    # 
    # + ids - Retrieve only orders specified by a comma-separated list of order IDs
    # + limit - The maximum number of results to show on a page. (default: 50, maximum: 250)
    # + fromId - Show orders after the specified ID
    # + createdAfter - Show orders created at or after date
    # + createdBefore - Show orders created at or before date
    # + updatedAfter - Show orders last updated at or after date
    # + updatedBefore - Show orders last updated at or before date
    # + processedAfter - Show orders imported at or after date
    # + processedBefore - Show orders imported at or before date
    # + attributionAppId - Show orders attributed to a certain app, specified by the app ID. Set as current to show orders for the app currently consuming the API
    # + status - Filter orders by their status. The default value is `shopify:ORDER_OPEN`
    # + financialStatus - Filter orders by their financial status. The default value is `shopify:FINANTIAL_ANY`
    # + fulfillmentStatus - Filter orders by their fulfillment status. The default value is `shopify:FULFILLMENT_ANY`
    # + fields - Specify the list of fields of the `Order` record to retrieve
    # + return - An array of `Order` records if the request is successful, or else an `Error` 
    public remote function getAll(int limit = 50, string[]? ids = (), string? fromId = (), time:Time? createdAfter = (),
        time:Time? createdBefore = (), time:Time? updatedAfter = (), time:Time? updatedBefore = (),
        time:Time? processedAfter = (), time:Time? processedBefore = (),
        string? attributionAppId = (), OrderStatus? status = (),
        FinancialStatus? financialStatus = (),
        FulfillmentStatus? fulfillmentStatus = (),
        string[]? fields = ()) returns @tainted Order[]|Error {}

    # Retrieves a specific order using the record ID.
    # 
    # + id - The ID of the order to be retrieved
    # + fields - Specify a list of fields of the `Order` record to retrieve
    # + return - The `Order` record of the given ID if the operation succeeded, or else an `Error`
    public remote function get(string id, string[]? fields = ()) returns Order|Error {}

    # Retrieves the order count.
    # 
    # + createdAfter - Get the count of the orders created at or after date
    # + createdBefore - Get the count of the orders created at or before date
    # + updatedAfter - Show orders last updated at or after date
    # + updatedBefore - Get the count of the orders last updated at or before date
    # + status - Get the count of the orders by their status. The default value is `shopify:ORDER_OPEN`
    # + financialStatus - Get the count of the orders by their financial status. The default value is `shopify:FINANTIAL_ANY`
    # + fulfillmentStatus - Get the count of the orders by their fulfillment status. The default value is `shopify:FULFILLMENT_ANY`
    # + return - Number of orders matching the given criteria
    public remote function getCount(time:Time? createdAfter = (),
        time:Time? createdBefore = (), time:Time? updatedAfter = (), time:Time? updatedBefore = (),
        OrderStatus? status = (), FinancialStatus? financialStatus = (), FulFillmentStatus? fulfillmentStatus = ())
    returns int? {}

    # Closes the given order.
    # 
    # + id - The ID of the order to be closed
    # + return - The `Order` record of the closed order if the operation succeeded, or else An `Error`
    public remote function close(string id) returns Order|Error {}

    # Reopens the given (previously closed) order.
    # 
    # + id - The ID of the order to be reopened
    # + return - The `Order` record of the reopened order if the operation succeeded, or else An `Error`
    public remote function reopen(string id) returns Order|Error {}

    # Cancels the given order.
    # 
    # + id - The ID of the order to be cancelled
    # + amount - The amount to be refunded, if required
    # + currency - The currency of the refund. This is required for the multi-currency orders, whenever the `amount` is specified
    # + reason - Reason for the cancellation. The default value is `shopify:CANCEL_OTHER`
    # + sendEmailNotification - Whether to send an email notification to the customer about the cancellation. Default value is `false`
    # + note - Any other notes on the cancellation
    # + return - The `Order` record of the cancelled order if the operation succeeded, or else An `Error`
    public remote function cancel(string id, float? amount = (), Currency? currency = (), CancellationReason? reason = (), boolean sendEmailNotification = false, string? note = ()) returns Order|Error {}

    # Creates an order.
    # 
    # + order - The `Order` record with the details of the order to be created
    # + sendConfirmationReceipt - Specify whether to send an order confirmation to the customer or not. Default value is `false`
    # + sendFulfillmentReceipt - Specify whether to send a shipping confirmation receipt to the customer. Default value is `false`
    # + inventoryBehaviour - The inventory update behavior. Default value is `shopify:INVENTORY_BYPASS`
    # + return - The `Order` record with all the updated fields if the operation is succeeded, or else an `Error`
    public remote function create(Order order, boolean sendConfirmationReceipt = false, boolean sendFulfillmentReceipt = false, InventoryBehaviour? inventoryBehaviour = ()) returns Order|Error {}

    # Updates an order.
    # 
    # + order - The `Order` record of the order to be updated, with the updated fields
    # + return -  The updated `Order` record if the order is successfully updated, or else an `Error`
    public remote function update(Order order) returns Order|Error {}

    # Deletes an order. Orders that interact with an online gateway can't be deleted.
    # 
    # + id - The ID of the order to be deleted
    # + return -  `()` if the order is successfully deleted, or else an `Error`
    public remote function delete(string id) returns Error? {}
};