import ballerina/test;
// import ballerina/time;

// time:Time createdTime = <time:Time>getTimeRecordFromTimeString("2020-06-10T04:27:07-04:00");
// time:Time updatedTime = <time:Time>getTimeRecordFromTimeString("2020-06-10T04:27:07-04:00");
// time:Time marketingUpdatedTime = <time:Time>getTimeRecordFromTimeString("2020-06-10T04:27:07-04:00");

// Address address = {
//     id: 4467764691109,
//     customerId: 3663856566437,
//     firstName: "John",
//     lastName: "Doe",
//     company: "example",
//     address1: "number",
//     address2: "at street",
//     city: "at city",
//     province: "",
//     country: "Sri Lanka",
//     zip: "40404",
//     phone: "+94734567890",
//     name: "John Doe",
//     provinceCode: (),
//     countryCode: "LK",
//     countryName: "Sri Lanka",
//     'default: true
// };
// Customer customer = {
//     id: 3663856566437,
//     email: "john.doe@example.com",
//     acceptsMarketing: true,
//     createdAt: createdTime,
//     updatedAt: updatedTime,
//     firstName: "John",
//     lastName: "Doe",
//     ordersCount: 0,
//     state: "disabled",
//     totalSpent: 0.00,
//     lastOrderId: (),
//     note: "",
//     verifiedEmail: true,
//     multipassIdentifier: (),
//     taxExempt: true,
//     phone: "+94714567890",
//     tags: "",
//     lastOrderName: (),
//     currency: "LKR",
//     addresses: [address],
//     acceptsMarketingUpdatedAt: marketingUpdatedTime,
//     marketingOptInLevel: MARKETING_SINGLE,
//     taxExemptions: [],
//     adminGraphqlApiId: "gid://shopify/Customer/3663856566437",
//     defaultAddress: address
// };

OAuthConfiguration oAuthConfiguration = {
    accessToken: ACCESS_TOKEN
};
StoreConfiguration storeConfiguration = {
    storeName: STORE_NAME,
    authConfiguration: oAuthConfiguration
};
Store store = new (storeConfiguration);

// @test:Config {}
// function getAllCustomersTest() {
//     Customer[] customers = [customer];

//     CustomerClient customerClient = store.getCustomerClient();

//     CustomerFilter filter = {
//         ids: [3663856566437]
//     };
//     Customer[]|Error result = customerClient->getAll(filter);
//     if (result is Error) {
//         test:assertFail(result.toString());
//     } else {
//         test:assertEquals(result, customers);
//     }
// }

// @test:Config {}
// function getAllCustomersWithFilters() {
//     Customer expectedCustomer = {
//         id: 3663856566437,
//         email: "john.doe@example.com",
//         firstName: "John",
//         lastName: "Doe"
//     };
//     Customer[] expectedCustomers = [expectedCustomer];

//     CustomerClient customerClient = store.getCustomerClient();

//     CustomerFilter filter = {
//         ids: [3663856566437],
//         createdDateFilter: {
//             after: createdTime
//         },
//         fields: ["firstName", "lastName", "email", "id"]
//     };
//     Customer[]|Error result = customerClient->getAll(filter);
//     if (result is Error) {
//         test:assertFail(result.toString());
//     } else {
//         test:assertEquals(result, expectedCustomers);
//     }
// }

// @test:Config {
//     dependsOn: ["addCustomerTest", "deleteCustomerTest"]
// }
// function getCustomerCountTest() {
//     CustomerClient customerClient = store.getCustomerClient();
//     int|Error result = customerClient->getCount();
//     if (result is Error) {
//         test:assertFail(result.toString());
//     } else {
//         test:assertEquals(result, 1);
//     }
// }

// int customerId = 0;

// @test:Config {}
// function addCustomerTest() {
//     NewCustomer customer = {
//         id: 85418,
//         email: "john.lennon@example.com",
//         firstName: "John",
//         lastName: "Lennon",
//         acceptsMarketing: true
//     };
//     CustomerClient customerClient = store.getCustomerClient();
//     Customer|Error result = customerClient->create(customer);
//     if (result is Error) {
//         test:assertFail(result.toString());
//     } else {
//         customerId = <@untainted int>result?.id;
//     }
// }

// @test:Config {
//     dependsOn: ["addCustomerTest"]
// }
// function deleteCustomerTest() {
//     CustomerClient customerClient = store.getCustomerClient();
//     Error? result = customerClient->remove(customerId);
//     if (result is Error) {
//         test:assertFail(result.toString());
//     }
// }

@test:Config {}
function testGetAllCustomersWithPagination() {
    NewCustomer newCustomer1 = {
        firstName: "Thisaru",
        lastName: "Guruge"
    };

    NewCustomer newCustomer2 = {
        firstName: "Ruwangika",
        lastName: "Gunawardana"
    };

    NewCustomer newCustomer3 = {
        firstName: "Supun",
        lastName: "Sarathchandra"
    };

    NewCustomer newCustomer4 = {
        firstName: "Lahiru",
        lastName: "Perera"
    };

    CustomerClient customerClient = store.getCustomerClient();
    var result1 = customerClient->create(newCustomer1);
    var result2 = customerClient->create(newCustomer2);
    var result3 = customerClient->create(newCustomer3);
    var result4 = customerClient->create(newCustomer4);

    test:assertTrue(result1 is Customer, result1.toString());
    test:assertTrue(result2 is Customer, result2.toString());
    test:assertTrue(result3 is Customer, result3.toString());
    test:assertTrue(result4 is Customer, result4.toString());

    Customer customer1 = <Customer>result1;
    Customer customer2 = <Customer>result2;
    Customer customer3 = <Customer>result3;
    Customer customer4 = <Customer>result4;

    int id1 = <@untainted int>customer1?.id;
    int id2 = <@untainted int>customer2?.id;
    int id3 = <@untainted int>customer3?.id;
    int id4 = <@untainted int>customer4?.id;

    CustomerFilter filter = {
        limit: 2,
        fields: ["firstName", "lastName", "email", "id"]
    };

    Customer[]|Error result = customerClient->getAll(filter);
    if (result is Error) {
        test:assertFail(result.toString());
    }

    Error? removeResult1 = customerClient->remove(id1);
    Error? removeResult2 = customerClient->remove(id2);
    Error? removeResult3 = customerClient->remove(id3);
    Error? removeResult4 = customerClient->remove(id4);
}
