public type Error error<ERROR_REASON, Detail>;

public type FinancialStatus FINANTIAL_ANY;
public type FulfillmentStatus FULFILLMENT_ANY|FULFILLMENT_FULFILLED|FULFILLMENT_RESTOCKED;
public type OrderStatus ORDER_OPEN|ORDER_CLOSED|ORDER_CANCELLED|ORDER_ANY;
public type Currency CURRENCY_USD;
public type CancellationReason CANCEL_OTHER;
public type InventoryBehaviour INVENTORY_BYPASS;
public type CustomerState CUSTOMER_DISABLED|CUSTOMER_ENABLED;
public type MarketingOptLevel MARKETING_SINGLE;

public type PublishedStatus PRODUCT_PUBLISHED|PRODUCT_UNPUBLISHED|PRODUCT_ANY;
