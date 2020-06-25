public type OrderClient client object {

    private Store store;

    # Creates a `OrderClient` object to handle order-related operations.
    # 
    # + store - The `shopify:Store` client object
    public function __init(Store store) {
        self.store = store;
    }

    # Retrieves all the orders placed in the store. This supports pagination.
    # 
    # + limit - The maximum number of results to show on a page. The default
    #           values is 50, and the maximum values 250
    # + fields - The expected fields from the customer record. By default, all the fields will be retrieved
    # + filter - Provide additional filters to filter the orders
    # + return - An array of `Order` records if the request is successful, or
    #            else an `Error` 
    public remote function getAll(int limit, string[]? fields = (), OrderFilter? filter = ()) returns @tainted Order[]|Error {
        return getAllOrders(limit, fields, filter);
    }

    // TODO: Make fields a record type with booolean values
    # Retrieves a specific order using the record ID.
    # 
    # + id - The ID of the order to be retrieved
    # + fields - Specify a list of fields of the `Order` record to retrieve
    # + return - The `Order` record of the given ID if the operation succeeded, or else an `Error`
    public remote function get(string id, string[]? fields = ()) returns Order|Error {
        return getOrder(id, fields);
    }

    // TODO: Review filter - Some fileds not allowed
    # Retrieves the order count.
    # 
    # + filter - Provide additional filters to filter the orders
    # + return - Number of orders matching the given criteria
    public remote function getCount(OrderFilter filter) returns int? {
        return getOrderCount(filter);
    }

    # Closes the given order.
    # 
    # + id - The ID of the order to be closed
    # + return - The `Order` record of the closed order if the operation succeeded, or else An `Error`
    public remote function close(string id) returns Order|Error {
        return closeOrder(id);
    }

    # Reopens the given (previously closed) order.
    # 
    # + id - The ID of the order to be reopened
    # + return - The `Order` record of the reopened order if the operation succeeded, or else An `Error`
    public remote function open(string id) returns Order|Error {
        return openOrder(id);
    }

    # Cancels the given order.
    # 
    # + id - The ID of the order to be cancelled
    # + amount - The amount to be refunded, if required
    # + currency - The currency of the refund. This is required for the multi-currency orders, whenever the `amount` is specified
    # + reason - Reason for the cancellation. The default value is `shopify:CANCEL_OTHER`
    # + sendEmailNotification - Whether to send an email notification to the customer about the cancellation. Default value is `false`
    # + note - Any other notes on the cancellation
    # + return - The `Order` record of the cancelled order if the operation succeeded, or else An `Error`
    public remote function cancel(string id, float? amount = (), Currency? currency = (), CancellationReason? reason = (), boolean sendEmailNotification = false, string? note = ()) returns Order|Error {
        return cancelOrder();
    }

    # Creates an order.
    # 
    # + order - The `Order` record with the details of the order to be created
    # + sendConfirmationReceipt - Specify whether to send an order confirmation to the customer or not. Default value is `false`
    # + sendFulfillmentReceipt - Specify whether to send a shipping confirmation receipt to the customer. Default value is `false`
    # + inventoryBehaviour - The inventory update behavior. Default value is `shopify:INVENTORY_BYPASS`
    # + return - The `Order` record with all the updated fields if the operation is succeeded, or else an `Error`
    public remote function create(Order order, boolean sendConfirmationReceipt = false, boolean sendFulfillmentReceipt = false, InventoryBehaviour? inventoryBehaviour = ()) returns Order|Error {
        return createOrder();
    }

    # Updates an order.
    # 
    # + order - The `Order` record of the order to be updated, with the updated fields
    # + return -  The updated `Order` record if the order is successfully updated, or else an `Error`
    public remote function update(Order order) returns Order|Error {
        return updateOrder(order);
    }

    # Deletes an order. Orders that interact with an online gateway can't be deleted.
    # 
    # + id - The ID of the order to be deleted
    # + return -  `()` if the order is successfully deleted, or else an `Error`
    public remote function delete(string id) returns Error? {
        return deleteOrder(id);
    }
};