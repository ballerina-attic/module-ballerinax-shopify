// Paths
const HTTPS = "https://";
const API_PATH = "/admin/api/2020-04";
const SHOPIFY_URL = ".myshopify.com";
const CUSTOMER_API_PATH = "/customers";
const ORDER_API_PATH = "/orders";
const PRODUCT_API_PATH = "/products";
const COUNT_PATH = "/count";
const ACTIVATION_URL = "account_activation_url";
const JSON = ".json";

const OAUTH_HEADER_KEY = "X-Shopify-Access-Token";

public const ERROR_REASON = "{ballerinax/shopify}Error";

const ERRORS_FIELD = "errors";

public const FINANTIAL_ANY = "any";

public const FULFILLMENT_ANY = "any";
public const FULFILLMENT_FULFILLED = "fulfilled";
public const FULFILLMENT_RESTOCKED = "restocked";

public const ORDER_OPEN = "open";
public const ORDER_CLOSED = "closed";
public const ORDER_CANCELLED = "cancelled";
public const ORDER_ANY = "any";

public const CURRENCY_USD = "USD";

public const CANCEL_OTHER = "other";

public const INVENTORY_BYPASS = "bypass";

public const CUSTOMER_DISABLED = "disabled";
public const CUSTOMER_ENABLED = "enabled";

public const PRODUCT_PUBLISHED = "published";
public const PRODUCT_UNPUBLISHED = "unpublished";
public const PRODUCT_ANY = "any";

public const MARKETING_SINGLE = "single_opt_in";

const DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ssz";

// JSON map fileds
const COUNT = "count";

// Query parameter fields
const UPDATED_BEFORE = "updated_at_max";
const UPDATED_AFTER = "updated_at_min";

const PAGE_MAX_LIMIT = 250;

// Headers
const LINK_HEADER = "link";

// Charset
const UTF8 = "utf-8";

// MetaField Value Types
const INTEGER = "integer";
const STRING = "srting";
const JSON_STRING = "json_string";

// Inventory Policy
public const INVENTORY_DENY = "deny";
public const INVENTORY_CONTINUE = "continue";
