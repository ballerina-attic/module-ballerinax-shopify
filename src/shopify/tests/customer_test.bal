import ballerina/test;
import ballerina/time;

const JOHN_DOE_ID = 3663856566437;

time:Time createdTime = <time:Time>getTimeRecordFromTimeString("2020-06-10T04:27:07-04:00");
time:Time updatedTime = <time:Time>getTimeRecordFromTimeString("2020-06-10T04:27:07-04:00");
time:Time marketingUpdatedTime = <time:Time>getTimeRecordFromTimeString("2020-06-10T04:27:07-04:00");

Address address = {
    id: 4467764691109,
    customerId: JOHN_DOE_ID,
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
    id: JOHN_DOE_ID,
    email: "john.doe@example.com",
    acceptsMarketing: true,
    createdAt: createdTime,
    updatedAt: updatedTime,
    firstName: "John",
    lastName: "Doe",
    ordersCount: 0,
    state: "disabled",
    totalSpent: 0.00,
    lastOrderId: (),
    note: "",
    verifiedEmail: true,
    multipassIdentifier: (),
    taxExempt: true,
    phone: "+94714567890",
    tags: "",
    lastOrderName: (),
    currency: "LKR",
    addresses: [address],
    acceptsMarketingUpdatedAt: marketingUpdatedTime,
    marketingOptInLevel: MARKETING_SINGLE,
    taxExemptions: [],
    adminGraphqlApiId: "gid://shopify/Customer/3663856566437",
    defaultAddress: address
};

CustomerClient customerClient = store.getCustomerClient();

@test:Config {}
function getAllCustomersTest() {
    Customer[] customers = [customer];

    CustomerFilter filter = {
        ids: [JOHN_DOE_ID]
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
        id: JOHN_DOE_ID,
        email: "john.doe@example.com",
        firstName: "John",
        lastName: "Doe"
    };
    Customer[] expectedCustomers = [expectedCustomer];

    CustomerFilter filter = {
        ids: [JOHN_DOE_ID],
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
    var result = customerClient->get(JOHN_DOE_ID);
    if (result is Error) {
        test:assertFail(result.toString());
    } else {
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

int customerId = 0;

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
        customerId = <@untainted int>result?.id;
    }
}

@test:Config {
    dependsOn: ["addCustomerTest"]
}
function deleteCustomerTest() {
    Error? result = customerClient->remove(customerId);
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
function testGetAllCustomersWithPagination() {

    Customer expectedCustomer0 = {
        firstName: "Tom",
        lastName: "Riddle",
        email: "tom@example.com"
    };

    Customer expectedCustomer1 = {
        firstName: "Lahiru",
        lastName: "Perera",
        email: ()
    };

    Customer expectedCustomer2 = {
        firstName: "Supun",
        lastName: "Sarathchandra",
        email: ()
    };

    Customer expectedCustomer3 = {
        firstName: "Ruwangika",
        lastName: "Gunawardana",
        email: ()
    };

    Customer expectedCustomer4 = {
        firstName: "Thisaru",
        lastName: "Guruge",
        email: ()
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
    CustomerClient customerClient = store.getCustomerClient();
    Error? result = customerClient->remove(id);
    if (result is Error) {
        test:assertFail("Failed to remove the Customer. " + result.toString());
    }
}
