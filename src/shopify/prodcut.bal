public type ProductClient client object {

    # Retrieves all the products in the store.
    # 
    # + return - An array of `Product` records if the request is successful, or else an `Error` 
    public remote function getAll() returns Product[]|Error {}

    # Retrieves the order count.
    # 
    # + return - Number of orders matching the given criteria if the operation succeeded, or else an `Error`
    public remote function getCount() returns int? {}

    # Retrieves a specific product using the product ID.
    # 
    # + id - The ID of the product to be retrieved
    # + fields - Specify a list of fields of the `Product` record to retrieve
    # + return - The `Product` record of the given ID if the operation succeeded, or else an `Error`
    public remote function get(string id, string[]? fields = ()) returns Product|Error {}

    # Creates a new product in shopify using the given `Product` record.
    # 
    # + product - The `Product` record consisting the information about the product
    # + metaTitle - The `<meta name = 'title'>` tag value. This is used for SEO purposes
    # + metaDescription - The `<meta name = 'description'>` tag value. This is used for SEO purposes
    # + return - The `Product` record with all the updated fields if the operation is succeeded, or else an `Error`
    public remote function create(Product product, string metaTitle, string metaDescription) returns Product|Error {}

    # Updates the given product in shopify.
    # 
    # + product - The `Product` record consisting the information about the product to be updated
    # + metaTitle - The `<meta name = 'title'>` tag value. This is used for SEO purposes
    # + metaDescription - The `<meta name = 'description'>` tag value. This is used for SEO purposes
    # + return - The `Product` record with all the updated fields if the operation is succeeded, or else an `Error`
    public remote function update(Product product, string metaTitle, string metaDescription) returns Product|Error {}

    # Deletes a product.
    # 
    # + id - The ID of the product to be deleted
    # + return -  `()` if the product is successfully deleted, or else an `Error`
    public remote function delete(string id) returns Error? {}
};