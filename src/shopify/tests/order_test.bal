import ballerina/test;

OrderClient orderClient = store.getOrderClient();

int ORDER_ID = 2559406571685;
json expectedOrderJson = {
    "id": 2559406571685,
    "email": "tom@example.com",
    "closed_at": null,
    "created_at": "2020-07-09T05:36:24-04:00",
    "updated_at": "2020-07-09T05:36:25-04:00",
    "number": 1,
    "note": null,
    "token": "d50daacb9633d6f71ce69a0bc7fec0e9",
    "gateway": "bogus",
    "test": true,
    "total_price": "115.00",
    "subtotal_price": "100.00",
    "total_weight": 0,
    "total_tax": "15.00",
    "taxes_included": false,
    "currency": "LKR",
    "financial_status": "paid",
    "confirmed": true,
    "total_discounts": "0.00",
    "total_line_items_price": "100.00",
    "cart_token": "",
    "buyer_accepts_marketing": false,
    "name": "#1001",
    "referring_site": "https://ballerina-store-test.myshopify.com/products/sample-product-1",
    "landing_site": "/wallets/checkouts.json",
    "cancelled_at": null,
    "cancel_reason": null,
    "total_price_usd": "0.62",
    "checkout_token": "0c07b9f87ac46a28575ccd09ba53477c",
    "reference": null,
    "user_id": null,
    "location_id": null,
    "source_identifier": null,
    "source_url": null,
    "processed_at": "2020-07-09T05:36:23-04:00",
    "device_id": null,
    "phone": null,
    "customer_locale": "en",
    "app_id": 580111,
    "browser_ip": "123.231.105.64",
    "landing_site_ref": null,
    "order_number": 1001,
    "discount_applications": [],
    "discount_codes": [],
    "note_attributes": [],
    "payment_gateway_names": [
            "bogus"
        ],
    "processing_method": "direct",
    "checkout_id": 14380782846117,
    "source_name": "web",
    "fulfillment_status": null,
    "tax_lines": [
            {
                "price": "15.00",
                "rate": 0.15,
                "title": "VAT",
                "price_set": {
                    "shop_money": {
                        "amount": "15.00",
                        "currency_code": "LKR"
                    },
                    "presentment_money": {
                        "amount": "15.00",
                        "currency_code": "LKR"
                    }
                }
            }
        ],
    "tags": "",
    "contact_email": "tom@example.com",
    "order_status_url": "https://ballerina-store-test.myshopify.com/39924367525/orders/d50daacb9633d6f71ce69a0bc7fec0e9/authenticate?key=58feb4f6760534b2bf63a42deffd16c5",
    "presentment_currency": "LKR",
    "total_line_items_price_set": {
        "shop_money": {
            "amount": "100.00",
            "currency_code": "LKR"
        },
        "presentment_money": {
            "amount": "100.00",
            "currency_code": "LKR"
        }
    },
    "total_discounts_set": {
        "shop_money": {
            "amount": "0.00",
            "currency_code": "LKR"
        },
        "presentment_money": {
            "amount": "0.00",
            "currency_code": "LKR"
        }
    },
    "total_shipping_price_set": {
        "shop_money": {
            "amount": "0.00",
            "currency_code": "LKR"
        },
        "presentment_money": {
            "amount": "0.00",
            "currency_code": "LKR"
        }
    },
    "subtotal_price_set": {
        "shop_money": {
            "amount": "100.00",
            "currency_code": "LKR"
        },
        "presentment_money": {
            "amount": "100.00",
            "currency_code": "LKR"
        }
    },
    "total_price_set": {
        "shop_money": {
            "amount": "115.00",
            "currency_code": "LKR"
        },
        "presentment_money": {
            "amount": "115.00",
            "currency_code": "LKR"
        }
    },
    "total_tax_set": {
        "shop_money": {
            "amount": "15.00",
            "currency_code": "LKR"
        },
        "presentment_money": {
            "amount": "15.00",
            "currency_code": "LKR"
        }
    },
    "line_items": [
            {
                "id": 5631244992677,
                "variant_id": 35012701421733,
                "title": "Sample Product 1",
                "quantity": 1,
                "sku": "123",
                "variant_title": "Black / 42",
                "vendor": "Ballerina",
                "fulfillment_service": "manual",
                "product_id": 5390310015141,
                "requires_shipping": true,
                "taxable": true,
                "gift_card": false,
                "name": "Sample Product 1 - Black / 42",
                "variant_inventory_management": null,
                "properties": [],
                "product_exists": true,
                "fulfillable_quantity": 1,
                "grams": 0,
                "price": "100.00",
                "total_discount": "0.00",
                "fulfillment_status": null,
                "price_set": {
                    "shop_money": {
                        "amount": "100.00",
                        "currency_code": "LKR"
                    },
                    "presentment_money": {
                        "amount": "100.00",
                        "currency_code": "LKR"
                    }
                },
                "total_discount_set": {
                    "shop_money": {
                        "amount": "0.00",
                        "currency_code": "LKR"
                    },
                    "presentment_money": {
                        "amount": "0.00",
                        "currency_code": "LKR"
                    }
                },
                "discount_allocations": [],
                "duties": [],
                "admin_graphql_api_id": "gid://shopify/LineItem/5631244992677",
                "tax_lines": [
                        {
                            "title": "VAT",
                            "price": "15.00",
                            "rate": 0.15,
                            "price_set": {
                                "shop_money": {
                                    "amount": "15.00",
                                    "currency_code": "LKR"
                                },
                                "presentment_money": {
                                    "amount": "15.00",
                                    "currency_code": "LKR"
                                }
                            }
                        }
                    ],
                "origin_location": {
                    "id": 2220722585765,
                    "country_code": "LK",
                    "province_code": "",
                    "name": "ballerina-store-test",
                    "address1": "Rockhill",
                    "address2": "",
                    "city": "Nawalapitiya",
                    "zip": "20160"
                }
            }
        ],
    "fulfillments": [],
    "refunds": [],
    "total_tip_received": "0.0",
    "original_total_duties_set": null,
    "current_total_duties_set": null,
    "admin_graphql_api_id": "gid://shopify/Order/2559406571685",
    "shipping_lines": [
            {
                "id": 2105140117669,
                "title": "Standard",
                "price": "0.00",
                "code": "Standard",
                "source": "shopify",
                "phone": null,
                "requested_fulfillment_service_id": null,
                "delivery_category": null,
                "carrier_identifier": null,
                "discounted_price": "0.00",
                "price_set": {
                    "shop_money": {
                        "amount": "0.00",
                        "currency_code": "LKR"
                    },
                    "presentment_money": {
                        "amount": "0.00",
                        "currency_code": "LKR"
                    }
                },
                "discounted_price_set": {
                    "shop_money": {
                        "amount": "0.00",
                        "currency_code": "LKR"
                    },
                    "presentment_money": {
                        "amount": "0.00",
                        "currency_code": "LKR"
                    }
                },
                "discount_allocations": [],
                "tax_lines": []
            }
        ],
    "billing_address": {
        "first_name": "Tom",
        "address1": "Common Room",
        "phone": null,
        "city": "Hogwarts",
        "zip": "40404",
        "province": null,
        "country": "Sri Lanka",
        "last_name": "Riddle",
        "address2": "House of Slytherin",
        "company": null,
        "latitude": null,
        "longitude": null,
        "name": "Tom Riddle",
        "country_code": "LK",
        "province_code": null
    },
    "shipping_address": {
        "first_name": "Tom",
        "address1": "Common Room",
        "phone": null,
        "city": "Hogwarts",
        "zip": "40404",
        "province": null,
        "country": "Sri Lanka",
        "last_name": "Riddle",
        "address2": "House of Slytherin",
        "company": null,
        "latitude": null,
        "longitude": null,
        "name": "Tom Riddle",
        "country_code": "LK",
        "province_code": null
    },
    "client_details": {
        "browser_ip": "123.231.105.64",
        "accept_language": "en-GB,en-US;q=0.9,en;q=0.8",
        "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36",
        "session_hash": null,
        "browser_width": 1665,
        "browser_height": 943
    },
    "payment_details": {
        "credit_card_bin": "1",
        "avs_result_code": null,
        "cvv_result_code": null,
        "credit_card_number": "•••• •••• •••• 1",
        "credit_card_company": "Bogus"
    },
    "customer": {
        "id": 3739582300325,
        "email": "tom@example.com",
        "accepts_marketing": false,
        "created_at": "2020-07-09T05:35:13-04:00",
        "updated_at": "2020-07-09T05:36:25-04:00",
        "first_name": "Tom",
        "last_name": "Riddle",
        "orders_count": 0,
        "state": "disabled",
        "total_spent": "0.00",
        "last_order_id": null,
        "note": null,
        "verified_email": true,
        "multipass_identifier": null,
        "tax_exempt": false,
        "phone": null,
        "tags": "",
        "last_order_name": null,
        "currency": "LKR",
        "accepts_marketing_updated_at": "2020-07-09T05:35:13-04:00",
        "marketing_opt_in_level": null,
        "tax_exemptions": [],
        "admin_graphql_api_id": "gid://shopify/Customer/3739582300325",
        "default_address": {
            "id": 4587558240421,
            "customer_id": 3739582300325,
            "first_name": "Tom",
            "last_name": "Riddle",
            "company": null,
            "address1": "Common Room",
            "address2": "House of Slytherin",
            "city": "Hogwarts",
            "province": null,
            "country": "Sri Lanka",
            "zip": "40404",
            "phone": null,
            "name": "Tom Riddle",
            "province_code": null,
            "country_code": "LK",
            "country_name": "Sri Lanka",
            "default": true
        }
    }
};

@test:Config {}
function getAllOrdersTest() returns Error? {
    Order expectedOrder = check getOrderFromJson(expectedOrderJson);
    var getAllResult = orderClient->getAll();

    if (getAllResult is Error) {
        test:assertFail("Failed to retrieve Orders. " + getAllResult.toString());
    }
    stream<Order[]|Error> orderStream = <stream<Order[]|Error>>getAllResult;
    var nextSet = orderStream.next();

    if (nextSet is ()) {
        test:assertFail("No records received");
    }
    Order[]|Error value = <Order[]|Error>nextSet?.value;
    if (value is Error) {
        test:assertFail("Error occurred while retrieving Orders from the stream. " + value.toString());
    }
}

@test:Config {}
function getOrderTest() returns Error? {
    Order expectedOrder = check getOrderFromJson(expectedOrderJson);
    Order|Error actualOrder = orderClient->get(ORDER_ID);
    if (actualOrder is Error) {
        test:assertFail("Failed to retrive the order count. " + actualOrder.toString());
    } else {
        test:assertEquals(actualOrder, expectedOrder);
    }
}

@test:Config {}
function getOrderCountTest() {
    int|Error count = orderClient->getCount();
    if (count is Error) {
        test:assertFail("Failed to retrive the order count. " + count.toString());
    } else {
        test:assertEquals(count, 1);
    }
}
