import ballerina/test;
import ballerina/time;
import ballerina/io;

const customerId = 3776780173473;

time:Time createdTime = <time:Time>getTimeRecordFromTimeString("2020-07-14T05:09:09-04:00");
time:Time updatedTime = <time:Time>getTimeRecordFromTimeString("2020-07-14T08:46:00-04:00");
time:Time marketingUpdatedTime = <time:Time>getTimeRecordFromTimeString("2020-07-14T08:46:00-04:00");

Address address = {
    id: 4494995980449,
    customerId: customerId,
    firstName: "John",
    lastName: "Doe",
    company: "example",
    address1: "number",
    address2: "at street",
    city: "at city",
    province: "",
    country: "Sri Lanka",
    zip: "40404",
    phone: "+94734567890",
    name: "John Doe",
    provinceCode: (),
    countryCode: "LK",
    countryName: "Sri Lanka",
    'default: true
};
Customer customer = {
    acceptsMarketing: false,
    acceptsMarketingUpdatedAt: marketingUpdatedTime,
    addresses: [address],
    adminGraphqlApiId: "gid://shopify/Customer/3776780173473",
    defaultAddress: address,
    currency: "USD",
    createdAt: createdTime,
    email: "john.doe@example.com",
    firstName: "John",
    id: customerId,
    lastName: "Doe",
    lastOrderId: 2569318891681,
    lastOrderName: "#1001",
    marketingOptInLevel: (),
    multipassIdentifier: (),
    note: (),
    ordersCount: 1,
    phone: "+94714567890",
    state: "disabled",
    tags: "",
    taxExempt: false,
    taxExemptions: [],
    totalSpent: "100.00",
    updatedAt: updatedTime,
    verifiedEmail: true
};

TestUtil customerTestUtil = new;
CustomerClient customerClient = customerTestUtil.getStore().getCustomerClient();

@test:Config {}
function getAllCustomersTest() {
    Customer[] customers = [customer];

    CustomerFilter filter = {
        ids: [customerId]
    };
    var result = customerClient->getAll(filter);
    if (result is Error) {
        test:assertFail(result.toString());
    } else {
        validateGetAllCustomersResult(result, customers);
    }
}

@test:Config {}
function getAllCustomersWithFilters() {
    Customer expectedCustomer = {
        id: customerId,
        email: "john.doe@example.com",
        firstName: "John",
        lastName: "Doe"
    };
    Customer[] expectedCustomers = [expectedCustomer];

    CustomerFilter filter = {
        ids: [customerId],
        createdAt: {
            after: createdTime
        },
        fields: ["firstName", "lastName", "email", "id"]
    };
    var result = customerClient->getAll(filter);
    if (result is Error) {
        test:assertFail(result.toString());
    } else {
        validateGetAllCustomersResult(result, expectedCustomers);
    }
}

@test:Config {}
function getCustomerTest() {
    var result = customerClient->get(customerId);
    if (result is Error) {
        test:assertFail(result.toString());
    } else {
        foreach string key in result.keys() {
            var actualValue = result[key];
            var expectedValue = customer[key];
            if (actualValue != expectedValue) {
                io:println("Key " + key + " not equal");
                if (actualValue is time:Time && expectedValue is time:Time) {
                    io:println("Expected: " + getTimeStringFromTimeRecord(expectedValue) + " | " + "Received: " + getTimeStringFromTimeRecord(actualValue));
                } else {
                    io:println("Expected: " + expectedValue.toString() + " | " + "Received: " + actualValue.toString());
                }
            }
        }
        test:assertEquals(result, customer);
    }
}

@test:Config {
    dependsOn: ["addCustomerTest", "deleteCustomerTest"]
}
function getCustomerCountTest() {
    int|Error result = customerClient->getCount();
    if (result is Error) {
        test:assertFail(result.toString());
    } else {
        test:assertEquals(result, 6);
    }
}

int createdCustomerId = 0;

@test:Config {}
function addCustomerTest() {
    NewCustomer customer = {
        email: "john.lennon@example.com",
        firstName: "John",
        lastName: "Lennon",
        acceptsMarketing: true
    };
    Customer|Error result = customerClient->create(customer);
    if (result is Error) {
        test:assertFail(result.toString());
    } else {
        createdCustomerId = <@untainted int>result?.id;
    }
}

@test:Config {
    dependsOn: ["addCustomerTest"]
}
function deleteCustomerTest() {
    Error? result = customerClient->remove(createdCustomerId);
    if (result is Error) {
        test:assertFail(result.toString());
    }
}

@test:Config {}
function deleteNonExistingCustomerTest() {
    Error? result = customerClient->remove(9999);
    if (result is Error) {
        test:assertEquals(result.detail().message, "Not Found");
    } else {
        test:assertFail("Non existing customer deletion did not returned an error");
    }
}

@test:Config {}
function searchCustomersTest() {
    Customer expectedCustomer = {
        firstName: "Thisaru",
        lastName: "Guruge",
        email: ()
    };
    CustomerSearchFilter filter = {
        fields: ["firstName", "lastName", "email"]
    };
    Customer[] expectedCustomers = [expectedCustomer];
    var result = customerClient->search("Thisaru", filter);
    if (result is Error) {
        test:assertFail(result.toString());
    } else {
        validateGetAllCustomersResult(result, expectedCustomers);
    }
}

@test:Config {}
function testGetAllCustomersWithPagination() {
    Customer expectedCustomer0 = {
        firstName: "Thisaru",
        lastName: "Guruge",
        email: ()
    };

    Customer expectedCustomer1 = {
        firstName: "Ruwangika",
        lastName: "Gunawardana",
        email: ()
    };

    Customer expectedCustomer2 = {
        firstName: "Supun",
        lastName: "Sarathchandra",
        email: ()
    };

    Customer expectedCustomer3 = {
        firstName: "Lahiru",
        lastName: "Perera",
        email: ()
    };

    Customer expectedCustomer4 = {
        firstName: "Tom",
        lastName: "Riddle",
        email: "tom@example.com"
    };

    Customer expectedCustomer5 = {
        firstName: "John",
        lastName: "Doe",
        email: "john.doe@example.com"
    };

    Customer[] expectedCustomers1 = [expectedCustomer0, expectedCustomer1];
    Customer[] expectedCustomers2 = [expectedCustomer2, expectedCustomer3];
    Customer[] expectedCustomers3 = [expectedCustomer4, expectedCustomer5];

    CustomerFilter filter = {
        limit: 2,
        fields: ["firstName", "lastName", "email"]
    };

    var result = customerClient->getAll(filter);
    if (result is Error) {
        test:assertFail(result.toString());
    } else {
        validateGetAllCustomersResult(result, expectedCustomers1);
        validateGetAllCustomersResult(result, expectedCustomers2);
        validateGetAllCustomersResult(result, expectedCustomers3);
    }
}

function validateGetAllCustomersResult(stream<Customer[]|Error> result, Customer[] expectedCustomers) {
    var customerRecord = result.next();
    if (customerRecord is ()) {
        test:assertFail("No records received");
    } else {
        Customer[]|Error actualCutomers = customerRecord?.value;
        if (actualCutomers is Error) {
            test:assertFail(actualCutomers.toString());
        } else {
            test:assertEquals(actualCutomers, expectedCustomers);
        }
    }
}

function removeCustomerFromStore(int id) {
    Error? result = customerClient->remove(id);
    if (result is Error) {
        test:assertFail("Failed to remove the Customer. " + result.toString());
    }
}
