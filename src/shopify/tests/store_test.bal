// import ballerina/test;
// import ballerina/http;

// @test:Config {}
// function oAuthTest() {
//     OAuthConfiguration oAuthConfiguration = {
//         accessToken: ACCESS_TOKEN
//     };
//     StoreConfiguration storeConfiguration = {
//         storeName: STORE_NAME,
//         authConfiguration: oAuthConfiguration
//     };
//     Store store = new(storeConfiguration);
//     http:Request request = new;
//     string token = request.getHeader(OAUTH_HEADER_KEY);
//     test:assertEquals(token, ACCESS_TOKEN);
// }
