//
//  User.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/18.
import Foundation

extension API {
    struct cartList: Post {
        typealias Node = CartList
        var path: String = "product/shopping_cart"

        init() {
        }

        func parameters() -> [String : Any]? {
            return ["":""]
        }
    }

    struct cartNumChange: Post {
        typealias Node = CartNumChange
        var path: String = "product/update_cart"

        let quantity: String
        let id: String
        init(quantity: String, id: String) {
            self.quantity = quantity
            self.id = id
        }

        func parameters() -> [String : Any]? {
            return ["quantity": quantity, "id": id]
        }
    }

    struct payList: Post {
        typealias Node = PayList
        var path: String = "order/payment_list"

        let order_id: String?
        init(order_id: String?) {
            self.order_id = order_id
        }

        func parameters() -> [String : Any]? {
            return ["order_id": order_id ?? ""]
        }
    }

    struct orderPay: Post {
        typealias Node = CartNumChange
        var path: String = "order/pay"

        let order_id: String
        let payment_pfn: String
        let payment_method: String
        init(order_id: String, payment_pfn: String, payment_method: String) {
            self.order_id = order_id
            self.payment_pfn = payment_pfn
            self.payment_method = payment_method
        }

        func parameters() -> [String : Any]? {
            return [
                "order_id": order_id,
                "payment_pfn": payment_pfn,
                "payment_method": payment_method
            ]
        }
    }

    struct orderSettlement: Post {

        typealias Node = OrderSettlement
        var path: String = "product/settlement"

        let shopping_cart_ids: [String]?
        let product_id: String?
        let quantity: String?
        let product_option_union_id: String?
        init(shopping_cart_ids: [String]?, product_id: String?, quantity: String?, product_option_union_id: String?) {
            self.shopping_cart_ids = shopping_cart_ids
            self.product_id = product_id
            self.quantity = quantity
            self.product_option_union_id = product_option_union_id
        }

        func parameters() -> [String : Any]? {
            return [
                "shopping_cart_ids": shopping_cart_ids ?? [],
                "product_id": product_id ?? "",
                "quantity": quantity ?? "",
                "product_option_union_id": product_option_union_id ?? ""
            ]
        }
    }

    struct createOrder: Post {
        typealias Node = CreatOrder
        var path: String = "order/confirm"

        let order_type: String
        let shopping_cart_ids: [String]?
        let product_id: String?
        let quantity: String?
        let product_option_union_id: String?
        let red_packet: String?
        let customer_coupon_id: String?
        let address_id: String?
        let self_store_id: String?
        init(order_type: String, shopping_cart_ids: [String]?, product_id: String?, quantity: String?, product_option_union_id: String?, red_packet: String?, customer_coupon_id: String?, address_id: String?, self_store_id: String?) {
            self.order_type = order_type
            self.shopping_cart_ids = shopping_cart_ids
            self.product_id = product_id
            self.quantity = quantity
            self.product_option_union_id = product_option_union_id
            self.red_packet = red_packet
            self.customer_coupon_id = customer_coupon_id
            self.address_id = address_id
            self.self_store_id = self_store_id
        }

        func parameters() -> [String : Any]? {
            return [
                "order_type": order_type,
                "shopping_cart_ids": shopping_cart_ids ?? [],
                "product_id": product_id ?? "",
                "quantity": quantity ?? "",
                "product_option_union_id": product_option_union_id ?? "",
                "red_packet": red_packet ?? "",
                "customer_coupon_id": customer_coupon_id ?? "",
                "address_id": address_id ?? "",
                "self_store_id": self_store_id ?? ""
            ]
        }
    }
}
// MARK: - CartList
struct CartList: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: [Datum]
}

struct CreatOrder: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: OrderId
}

struct OrderId: Codable {
    let order_id: String
}

struct CartNumChange: Codable {
    let result: Bool
    let message: String
    let status: Int
}

// MARK: - Datum
struct Datum: Codable {
    let id, name: String?
    let image: String
    let productID, productOptionUnionID, optionUnionName, weight: String
    let price, quantity: String

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case productID = "product_id"
        case productOptionUnionID = "product_option_union_id"
        case optionUnionName = "option_union_name"
        case weight, price, quantity
    }
}

// MARK: - PayList
struct PayList: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: PayDataClass
}

// MARK: - DataClass
struct PayDataClass: Codable {
    let orderID: String
    let payment: [Payment]
    let amount, price: String

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case payment, amount, price
    }
}

// MARK: - Payment
struct Payment: Codable {
    let id, name, type, pfn: String
    let status, paymentDescription, sort, created: String
    let modified: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, name, type, pfn, status
        case paymentDescription = "description"
        case sort, created, modified, icon
    }

    func getIcon() -> String {
        if icon.isEmpty {
            return "https://app.necesstore.com/upload/advert/o_10530652.jpg"
        } else {
            return icon
        }
    }
}


// MARK: - OrderSettlement
struct OrderSettlement: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: SettleDataClass
}

// MARK: - DataClass
struct SettleDataClass: Codable {
    let products: [Datum]
    let redPackage: String
    let address: AddressDatum
    let shippingFee: String
    let coupons: [SettlementCoupon]
    let stores: [Store]

    enum CodingKeys: String, CodingKey {
        case products
        case redPackage = "red_package"
        case address
        case shippingFee = "shipping_fee"
        case coupons, stores
    }
}

struct SettlementCoupon: Codable {
    let categoryIDS, couponType, detail: String
    let id, productIDS, useableValue: String
    let faceValue: String
    let end_time: String

    enum CodingKeys: String, CodingKey {
        case categoryIDS = "category_ids"
        case couponType = "coupon_type"
        case detail
        case end_time
        case faceValue = "face_value"
        case id
        case productIDS = "product_ids"
        case useableValue = "useable_value"
    }
}

// MARK: - Store
struct Store: Codable {
    let id, name, code, regionID: String
    let cityID, detail, telephone, openTime: String
    let longitude, latitude, status, adminID: String
    let created, modified, image: String
    let distance: Int

    enum CodingKeys: String, CodingKey {
        case id, name, code
        case regionID = "region_id"
        case cityID = "city_id"
        case detail, telephone
        case openTime = "open_time"
        case longitude, latitude, status
        case adminID = "admin_id"
        case created, modified, image, distance
    }
}

