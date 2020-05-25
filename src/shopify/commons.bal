public type StoreConfiguration record {
    string url;
    string username;
    string password;
};

public type Detail record {
    string message;
    error cause?;
};

public type Customer record {
    string id;
};

public type Invite record {

};

public type Order record {

};

public type Product record {

};

public const ERROR_REASON = "{ballerinax/shopify}Error";
public type Error error<ERROR_REASON, Detail>;


public const FINANTIAL_ANY = "any";

public const FULFILLMENT_ANY = "any";

public const ORDER_OPEN = "open";
public const ORDER_CLOSED = "closed";
public const ORDER_CANCELLED = "cancelled";
public const ORDER_ANY = "any";

public const CURRENCY_USD = "USD";

public const CANCEL_OTHER = "other";

public const INVENTORY_BYPASS = "bypass";

public type FinancialStatus FINANTIAL_ANY;
public type FulfillmentStatus ORDER_CLOSED;
public type OrderStatus ORDER_OPEN|ORDER_CLOSED|ORDER_CANCELLED|ORDER_ANY;
public type Currency CURRENCY_USD;
public type CancellationReason CANCEL_OTHER;
public type InventoryBehaviour INVENTORY_BYPASS;