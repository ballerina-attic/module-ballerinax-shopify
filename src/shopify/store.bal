public type StoreClient client object {

    private CustomerClient customerClient;
    private OrderClient orderClient;

    public function __init(StoreConfiguration storeConfiguration) {
        self.customerClient = new;
        self.orderClient = new;
    }

    public function getCustomerClient() returns CustomerClient {
        return self.customerClient;
    }

    public function getOrderClient() returns OrderClient {
        return self.orderClient;
    }
};