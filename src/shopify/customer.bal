public type CustomerClient client object {

    private Store store;

    # Creates a `CustomerClient` object to handle customer-related operations.
    # 
    # + store - The `shopify:Store` client object
    public function __init(Store store) {
        self.store = store;
    }

    # Retrieves the list of customers of the store. This API supports pagination.
    # 
    # + filter - Specify the filters when retrieving the customers
    # + return - A stream of `Customer[]` if the request is successful, or else an `Error` 
    public remote function getAll(CustomerFilter? filter = ()) returns @tainted stream<Customer[]|Error>|Error {
        return getAllCustomers(self, filter);
    }

    # Retrieves a specific customer using the customer ID.
    # 
    # + id - The ID of the customer to be retrieved
    # + fields - Specify the list of fields of the `Customer` record to retrieve. If the provided fields are incorrect,
    #            They will be ignored and the valid fields are returned
    # + return - The `Customer` record of the given ID if the operation succeeded, or else an `Error`
    public remote function get(int id, string[]? fields = ()) returns @tainted Customer|Error {
        return getCustomer(self, id, fields);
    }

    # Searches for customers matching the given query string.
    # 
    # + query - The query to search for Customers
    # + filter - The `CustomerSearchFilter` record to filter and order the results. The default value is null
    # + return - A stream of `Customer[]` if the request is successfull, or else an `Error`
    public remote function search(string query, CustomerSearchFilter? filter = ()) returns @tainted
        stream<Customer[]|Error>|Error {
        return searchCustomers(self, query, filter);
    }

    # Creates a new customer in the store and returns the created `Customer` record. This returned record includes all the details of the customer including the values set by the Shopify admin API.
    # 
    # + customer - The customer record with the details of the customer
    # + return - The created `Customer` record if the operation succeeded, an `Error` otherwise
    public remote function create(NewCustomer customer) returns @tainted Customer|Error {
        return createCustomer(self, customer);
    }

    # Updates the details of a given customer. 
    # 
    # + customer - The `Customer` record which should be updated, with the updated field values
    # + return - The updated `Customer` record if the operation succeeded, or else an `Error`
    public remote function update(Customer customer) returns @tainted Customer|Error {
        var id = customer?.id;
        if (id is ()) {
            return createError("Customer must have an ID to update");
        } else {
            return updateCustomer(self, customer, id);
        }
    }

    # Removes a given customer from the store. If the customer has any existing orders, the customer cannot be removed.
    # 
    # + id - The ID of the customer to be removed
    # + return - The updated `Customer` record if the operation succeeded, or else an `Error`
    public remote function remove(int id) returns Error? {
        return removeCustomer(self, id);
    }

    # Retrieves the total number of customers in the store.
    # 
    # + return - The total number of customers in the store
    public remote function getCount() returns @tainted int|Error {
        return getCustomerCount(self);
    }

    # Retrieves the orders from the given customer as an array.
    # 
    # + id - The ID of the customer to retrieve the orders
    # + return - An array of `Order` records of the given customer if the operation succeeded, or else an `Error`
    public remote function getOrders(int id) returns @tainted Order[]|Error {
        return getCustomerOrders(id);
    }

    # Creates an account activation URL for the customer. This will return an error if the customer is already activated. The URL is valid for 30 days. If this function is called again on a customer, a new URL will be created and the previously created URL will be invalid.
    # 
    # + id - The ID of the customer to be activated
    # + return - The account verification URL if the operation succeeded, or else an `Error`
    public remote function getActivationUrl(int id) returns @tainted string|Error {
        return getCustomerActivationUrl(self, id);
    }

    # Sends an invitation to the given customer.
    # 
    # + id - The ID of the customer to send the invite
    # + invite - The `Invite` record to be sent
    # + return - The `Invite` sent to the customer, or else an `Error`
    public remote function sendInvitation(int id, Invite invite) returns @tainted Invite|Error {
        return sendCustomerInvitation(id, invite);
    }

    function getStore() returns Store {
        return self.store;
    }
};
