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

# Represents a Shopify error.
public type Error distinct error;

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
public type AuthenticationConfiguration BasicAuthConfiguration|OAuth2Configuration;
