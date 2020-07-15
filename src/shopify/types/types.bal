# Represents a Shopify error.
public type Error error<ERROR_REASON, Detail>;

# Represents the possible financial statuses of an Order.
public type FinancialStatus FINANTIAL_PENDING|FINANTIAL_AUTHORIZED|FINANTIAL_PARTIALLY_PAID|FINANTIAL_PAID|
                            FINANTIAL_PARTIALLY_REFUNDED|FINANTIAL_REFUNDED|FINANTIAL_VOIDED;

# Represensts the possible fulfillment statuses of an Order.
public type FulfillmentStatus FULFILLMENT_ANY|FULFILLMENT_FULFILLED|FULFILLMENT_RESTOCKED;

# Represents the possible statuses of an Order.
public type OrderStatus ORDER_OPEN|ORDER_CLOSED|ORDER_CANCELLED|ORDER_ANY;

# Represents the possible order cancellation reasons.
public type CancellationReason CANCEL_OTHER|CANCEL_CUSTOMER|CANCEL_INVENTORY|CANCEL_FRAUD|CANCEL_DECLINED;

# Represents the possible inventory behaviours when an Order is modified.
public type InventoryBehaviour INVENTORY_BYPASS|INVENTORY_DECREMENT_IGNORING_POLICY|INVENTORY_DECREMENT_OBEYING_POLICY;

# Represents the possible statuses of a Customer.
public type CustomerState CUSTOMER_DISABLED|CUSTOMER_ENABLED;

# Represents the possible marketing opt in levels of a Customer.
public type MarketingOptLevel MARKETING_SINGLE|MARKETING_CONFIRMED|MARKETING_UNKNOWN;

# Represents the possible published statuses of a Product.
public type PublishedStatus PRODUCT_PUBLISHED|PRODUCT_UNPUBLISHED|PRODUCT_ANY;

# Represents the possible values of a metafield value types.
public type MetaFieldValueType INTEGER|STRING|JSON_STRING;

# Represents the possible values of the inventory policy of an Order.
public type InventoryPolicy INVENTORY_DENY|INVENTORY_CONTINUE;

type Filter CustomerFilter|OrderFilter|OrderCountFilter|ProductFilter|ProductCountFilter;

# Represents different types of AuthenticationConfigurations for the Shopify store app.
public type AuthenticationConfiguration BasicAuthConfiguration|OAuthConfiguration;
