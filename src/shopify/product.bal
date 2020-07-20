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

public type ProductClient client object {

    private Store store;

    # Creates a `ProductClient` object to handle order-related operations.
    # 
    # + store - The `shopify:Store` client object
    public function init(Store store) {
        self.store = store;
    }

    # Retrieves all the products in the store.
    # 
    # + filter - Provides additional filters to filter the products 
    # + return - A stream of `Product[]` if the request is successful or else an `Error` 
    public remote function getAll(ProductFilter? filter = ()) returns @tainted stream<Product[]>|Error {
        return getAllProducts(self, filter);
    }

    # Retrieves the order count.
    # 
    # + filter - Provides additional filters to filter the products 
    # + return - Number of orders matching the given criteria if the operation succeeded or else an `Error`
    public remote function getCount(ProductCountFilter? filter = ()) returns @tainted int|Error {
        return getProductCount(self, filter);
    }

    # Retrieves a specific product using the product ID.
    # 
    # + id - The ID of the product to be retrieved
    # + fields - Specifies a list of fields of the `Product` record to retrieve
    # + return - The `Product` record of the given ID if the operation succeeded or else an `Error`
    public remote function get(int id, string[]? fields = ()) returns @tainted Product|Error {
        return getProduct(self, id, fields);
    }

    # Creates a new product in Shopify using the given `Product` record.
    # 
    # + product - The `Product` record consisting the information about the product
    # + return - The `Product` record with all the updated fields if the operation is succeeded or else an `Error`
    public remote function create(NewProduct product) returns @tainted Product|Error {
        return createProduct(self, product);
    }

    # Updates the given product in Shopify.
    # 
    # + product - The `Product` record consisting the information about the product to be updated
    # + return - The `Product` record with all the updated fields if the operation is succeeded or else an `Error`
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
    # + return -  `()` if the product is successfully deleted or else an `Error`
    public remote function delete(int id) returns Error? {
        return deleteProduct(self, id);
    }

    function getStore() returns Store {
        return self.store;
    }
};
