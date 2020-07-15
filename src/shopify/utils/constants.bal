// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

// Paths
const HTTPS = "https://";
const SHOPIFY_URL = ".myshopify.com";

const API_PATH = "/admin/api/2020-04";
const CUSTOMER_API_PATH = "/customers";
const ORDER_API_PATH = "/orders";
const PRODUCT_API_PATH = "/products";
const SEARCH_PATH = "/search";
const COUNT_PATH = "/count";
const CLOSE_PATH = "/close";
const OPEN_PATH = "/open";
const CANCEL_PATH = "/cancel";
const SEND_INVITE_PATH = "/send_invite";
const ACTIVATION_URL = "account_activation_url";
const JSON = ".json";

// Authentication Header Key When OAuth is Used
const OAUTH_HEADER_KEY = "X-Shopify-Access-Token";

public const ERROR_REASON = "{ballerinax/shopify}Error";

const ERRORS_FIELD = "errors";

// Financial Statuses
public const FINANTIAL_PENDING = "pending";
public const FINANTIAL_AUTHORIZED = "authorized";
public const FINANTIAL_PARTIALLY_PAID = "partially_paid";
public const FINANTIAL_PAID = "paid";
public const FINANTIAL_PARTIALLY_REFUNDED = "partially_refunded";
public const FINANTIAL_REFUNDED = "refunded";
public const FINANTIAL_VOIDED = "voided";

// Fulfillment Statuses
public const FULFILLMENT_ANY = "any";
public const FULFILLMENT_FULFILLED = "fulfilled";
public const FULFILLMENT_RESTOCKED = "restocked";

// Order Statuses
public const ORDER_OPEN = "open";
public const ORDER_CLOSED = "closed";
public const ORDER_CANCELLED = "cancelled";
public const ORDER_ANY = "any";

// Cancellation Reasons
public const CANCEL_OTHER = "other";
public const CANCEL_CUSTOMER = "customer";
public const CANCEL_INVENTORY = "inventory";
public const CANCEL_FRAUD = "fraud";
public const CANCEL_DECLINED = "declined";

// Inventory Behaviour
public const INVENTORY_BYPASS = "bypass";
public const INVENTORY_DECREMENT_IGNORING_POLICY = "decrement_ignoring_policy";
public const INVENTORY_DECREMENT_OBEYING_POLICY = "decrement_obeying_policy";

// Customer Statuses
public const CUSTOMER_DISABLED = "disabled";
public const CUSTOMER_ENABLED = "enabled";

// Product Publication Statuses
public const PRODUCT_PUBLISHED = "published";
public const PRODUCT_UNPUBLISHED = "unpublished";
public const PRODUCT_ANY = "any";

// Marketing Opt In Levels
public const MARKETING_SINGLE = "single_opt_in";
public const MARKETING_CONFIRMED = "confirmed_opt_in";
public const MARKETING_UNKNOWN = "unknown";

// Supported Date Format in Shopify
const DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ssz";

// JSON map fields
const COUNT = "count";

// Query parameter fields
const CREATED_BEFORE = "created_at_max";
const CREATED_AFTER = "created_at_min";
const UPDATED_BEFORE = "updated_at_max";
const UPDATED_AFTER = "updated_at_min";
const PUBLISHED_BEFORE = "published_at_max";
const PUBLISHED_AFTER = "published_at_min";
const SUFFIX_MAX = "_max";
const SUFFIX_MIN = "_min";

// Max Limit of Records Per Page When Pagination is Supported
const PAGE_MAX_LIMIT = 250;

// Headers
const LINK_HEADER = "link";

// Charset
const UTF8 = "utf-8";

// MetaField Value Types
public const INTEGER = "integer";
public const STRING = "srting";
public const JSON_STRING = "json_string";

// Inventory Policy
public const INVENTORY_DENY = "deny";
public const INVENTORY_CONTINUE = "continue";

// Order By Types
const DESC = "DESC";
const ASC = "ASC";
