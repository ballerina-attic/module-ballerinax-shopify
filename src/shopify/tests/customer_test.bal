import ballerina/test;
import ballerina/time;

@test:Config {}
function getAllCustomersTest() returns error? {
    time:Time createdTime = check getTimeRecordFromTimeString("2020-06-10T04:27:07-04:00");
    time:Time updatedTime = check getTimeRecordFromTimeString("2020-06-10T04:27:07-04:00");
    time:Time marketingUpdatedTime = check getTimeRecordFromTimeString("2020-06-10T04:27:07-04:00");
    
    Address address = {
        id: 4467764691109,
        customerId: 3663856566437,
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
        id: 3663856566437,
        email: "john.doe@example.com",
        acceptsMarketing: true,
        createdAt: createdTime,
        updatedAt: updatedTime,
        firstName: "John",
        lastName: "Doe",
        ordersCount: 0,
        state: "disabled",
        totalSpent: "0.00",
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
    Customer[] customers = [customer];

    OAuthConfiguration oAuthConfiguration = {
        accessToken: ACCESS_TOKEN
    };
    StoreConfiguration storeConfiguration = {
        storeName: STORE_NAME,
        authConfiguration: oAuthConfiguration
    };
    Store store = new (storeConfiguration);
    CustomerClient customerClient = store.getCustomerClient();
    var result = customerClient->getAll();
    if (result is Error) {
        test:assertFail(result.detail().message);
    } else {
        test:assertEquals(result, customers);
    }
}
