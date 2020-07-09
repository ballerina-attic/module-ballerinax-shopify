public type ProductClient client object {

    private Store store;

    # Creates a `ProductClient` object to handle order-related operations.
    # 
    # + store - The `shopify:Store` client object
    public function __init(Store store) {
        self.store = store;
    }

    # Retrieves all the products in the store.
    # 
    # + filter - Provide additional filters to filter the prodcuts 
    # + return - A stream of `Product[]` if the request is successful, or else an `Error` 
    public remote function getAll(ProductFilter? filter = ()) returns @tainted stream<Product[]>|Error {
        return getAllProducts(self, filter);
    }

    # Retrieves the order count.
    # 
    # + filter - Provide additional filters to filter the prodcuts 
    # + return - Number of orders matching the given criteria if the operation succeeded, or else an `Error`
    public remote function getCount(ProductCountFilter? filter = ()) returns @tainted int|Error {
        return getProductCount(self, filter);
    }

    # Retrieves a specific product using the product ID.
    # 
    # + id - The ID of the product to be retrieved
    # + fields - Specify a list of fields of the `Product` record to retrieve
    # + return - The `Product` record of the given ID if the operation succeeded, or else an `Error`
    public remote function get(int id, string[]? fields = ()) returns @tainted Product|Error {
        return getProduct(self, id, fields);
    }

    # Creates a new product in shopify using the given `Product` record.
    # 
    # + product - The `Product` record consisting the information about the product
    # + return - The `Product` record with all the updated fields if the operation is succeeded, or else an `Error`
    public remote function create(NewProduct product) returns @tainted Product|Error {
        return createProduct(self, product);
    }

    # Updates the given product in shopify.
    # 
    # + product - The `Product` record consisting the information about the product to be updated
    # + return - The `Product` record with all the updated fields if the operation is succeeded, or else an `Error`
    public remote function update(Product product) returns @tainted Product|Error {
        var id = product?.id;
        if (id is ()) {
            return createError("Product must have an ID to update");
        } else {
            return updateProduct(self, product, id);
        }
    }

    # Deletes a product.
    # 
    # + id - The ID of the product to be deleted
    # + return -  `()` if the product is successfully deleted, or else an `Error`
    public remote function delete(int id) returns Error? {
        return deleteProduct(self, id);
    }

    function getStore() returns Store {
        return self.store;
    }
};
