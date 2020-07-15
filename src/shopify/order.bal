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
    # + filter - Provide additional filters to filter the orders
    # + return - A stream of `Order[]` if the request is successful, or else an `Error`
    public remote function getAll(OrderFilter? filter = ()) returns @tainted stream<Order[]>|Error {
        return getAllOrders(self, filter);
    }

    # Retrieves a specific order using the record ID.
    # 
    # + id - The ID of the order to be retrieved
    # + fields - Specify a list of fields of the `Order` record to retrieve
    # + return - The `Order` record of the given ID if the operation succeeded, or else an `Error`
    public remote function get(int id, string[]? fields = ()) returns @tainted Order|Error {
        return getOrder(self, id, fields);
    }

    # Retrieves the order count.
    # 
    # + filter - Provide additional filters to filter the orders
    # + return - Number of orders matching the given criteria
    public remote function getCount(OrderCountFilter? filter = ()) returns @tainted int|Error {
        return getOrderCount(self, filter);
    }

    # Closes the given order.
    # 
    # + id - The ID of the order to be closed
    # + return - The `Order` record of the closed order if the operation succeeded, or else An `Error`
    public remote function close(int id) returns @tainted Order|Error {
        return closeOrder(self, id);
    }

    # Reopens the given (previously closed) order.
    # 
    # + id - The ID of the order to be reopened
    # + return - The `Order` record of the reopened order if the operation succeeded, or else An `Error`
    public remote function open(int id) returns @tainted Order|Error {
        return openOrder(self, id);
    }

    # Cancels the given order.
    # 
    # + id - The ID of the order to be cancelled
    # + orderCancellationOptions - Additional options for cancellation of the Order
    # + return - The `Order` record of the cancelled order if the operation succeeded, or else An `Error`
    public remote function cancel(int id, OrderCancellationOptions? orderCancellationOptions = ()) returns Order|Error {
        return cancelOrder(self, id, orderCancellationOptions);
    }

    # Creates an order.
    # 
    # + order - The `NewOrder` record with the details of the order to be created
    # + return - The `Order` record with all the updated fields if the operation is succeeded, or else an `Error`
    public remote function create(NewOrder order) returns @tainted Order|Error {
        return createOrder(self, order);
    }

    # Updates an order.
    # 
    # + order - The `Order` record of the order to be updated, with the updated fields
    # + return -  The updated `Order` record if the order is successfully updated, or else an `Error`
    public remote function update(Order order) returns @tainted Order|Error {
        var id = order?.id;
        if (id is ()) {
            return createError("Order must have an ID to update");
        } else {
            return updateOrder(self, order, id);
        }
    }

    # Deletes an order. Orders that interact with an online gateway can't be deleted.
    # 
    # + id - The ID of the order to be deleted
    # + return -  `()` if the order is successfully deleted, or else an `Error`
    public remote function delete(int id) returns Error? {
        return deleteOrder(self, id);
    }

    function getStore() returns Store {
        return self.store;
    }
};
