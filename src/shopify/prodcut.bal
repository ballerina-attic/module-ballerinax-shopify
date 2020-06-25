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
    # + return - An array of `Product` records if the request is successful, or else an `Error` 
    public remote function getAll(ProductFilter filter) returns Product[]|Error {
        return getAllProducts(filter);
    }

    # Retrieves the order count.
    # 
    # + filter - Provide additional filters to filter the prodcuts 
    # + return - Number of orders matching the given criteria if the operation succeeded, or else an `Error`
    public remote function getCount(ProductFilter filter) returns int {
        return getProductCount();
    }

    # Retrieves a specific product using the product ID.
    # 
    # + id - The ID of the product to be retrieved
    # + fields - Specify a list of fields of the `Product` record to retrieve
    # + return - The `Product` record of the given ID if the operation succeeded, or else an `Error`
    public remote function get(string id, string[]? fields = ()) returns Product|Error {
        return getProduct();
    }

    # Creates a new product in shopify using the given `Product` record.
    # 
    # + product - The `Product` record consisting the information about the product
    # + metaTitle - The `<meta name = 'title'>` tag value. This is used for SEO purposes
    # + metaDescription - The `<meta name = 'description'>` tag value. This is used for SEO purposes
    # + return - The `Product` record with all the updated fields if the operation is succeeded, or else an `Error`
    public remote function create(Product product, string metaTitle, string metaDescription) returns Product|Error {
        return createProduct();
    }

    # Updates the given product in shopify.
    # 
    # + product - The `Product` record consisting the information about the product to be updated
    # + metaTitle - The `<meta name = 'title'>` tag value. This is used for SEO purposes
    # + metaDescription - The `<meta name = 'description'>` tag value. This is used for SEO purposes
    # + return - The `Product` record with all the updated fields if the operation is succeeded, or else an `Error`
    public remote function update(Product product, string metaTitle, string metaDescription) returns Product|Error {
        return updateProduct();
    }

    # Deletes a product.
    # 
    # + id - The ID of the product to be deleted
    # + return -  `()` if the product is successfully deleted, or else an `Error`
    public remote function delete(string id) returns Error? {
        return deleteProduct();
    }
};