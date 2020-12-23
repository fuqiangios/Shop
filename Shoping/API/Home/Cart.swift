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

    struct cartStatsChange: Post {
        typealias Node = ChangeCart
        var path: String = "product/change_cart"

        let status: String
        let ids: [String]
        init(status: String, ids: [String]) {
            self.status = status
            self.ids = ids
        }

        func parameters() -> [String : Any]? {
            return ["status": status, "ids": ids]
        }
    }

    struct invoiceInfo: Post {
        typealias Node = InvoiceInfo
        var path: String = "product/invoice_list"

        init() {
        }

        func parameters() -> [String : Any]? {
            return ["": ""]
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

    struct cartCollect: Post {
        typealias Node = ChangeCollectList
        var path: String = "product/collect"

        let order: String
        let page: String
        init(order: String, page: String) {
            self.order = order
            self.page = page
        }

        func parameters() -> [String : Any]? {
            return [
                "order": order,
                "page": page,
            ]
        }
    }

    struct deleteCart: Post {
        typealias Node = CartNumChange
        var path: String = "product/remove_cart"

        let id: [String]
        init(id: [String]) {
            self.id = id
        }

        func parameters() -> [String : Any]? {
            return [
                "id": id
            ]
        }
    }

    struct addInvoice: Post {
        typealias Node = AddInvoice
        var path: String = "product/invoice_add"

        let type: String
        let name: String
        let telephone: String
        let email: String
        let tax_num: String
        init(type: String, name: String, telephone: String, email: String, tax_num: String) {
            self.type = type
            self.name = name
            self.telephone = telephone
            self.email = email
            self.tax_num = tax_num
        }

        func parameters() -> [String : Any]? {
            return [
                "type": "1",
                "head_type": type,
                "name": name,
                "telephone": telephone,
                "email": email,
                "tax_num": tax_num
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
        let address_id: String
        init(shopping_cart_ids: [String]?, product_id: String?, quantity: String?, product_option_union_id: String?, address_id: String) {
            self.shopping_cart_ids = shopping_cart_ids
            self.product_id = product_id
            self.quantity = quantity
            self.product_option_union_id = product_option_union_id
            self.address_id = address_id
        }

        func parameters() -> [String : Any]? {
            return [
                "shopping_cart_ids": shopping_cart_ids ?? [],
                "product_id": product_id ?? "",
                "quantity": quantity ?? "",
                "address_id": address_id,
                "product_option_union_id": product_option_union_id ?? ""
            ]
        }
    }

    struct createOrder: Post {
        typealias Node = PayOrder
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
        let store_id: String
        let payment_pfn: String
        let payment_method: String
        let invoice_id: String
        let pay_password: String
        init(order_type: String, shopping_cart_ids: [String]?, product_id: String?, quantity: String?, product_option_union_id: String?, red_packet: String?, customer_coupon_id: String?, address_id: String?, self_store_id: String?, store_id: String, payment_pfn: String, payment_method: String, invoice_id: String, pay_password: String) {
            self.order_type = order_type
            self.shopping_cart_ids = shopping_cart_ids
            self.product_id = product_id
            self.quantity = quantity
            self.product_option_union_id = product_option_union_id
            self.red_packet = red_packet
            self.customer_coupon_id = customer_coupon_id
            self.address_id = address_id
            self.self_store_id = self_store_id
            self.store_id = store_id
            self.payment_pfn = payment_pfn
            self.payment_method = payment_method
            self.invoice_id = invoice_id
            self.pay_password = pay_password
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
                "self_store_id": self_store_id ?? "",
                "store_id": store_id,
                "payment_pfn": payment_pfn,
                "payment_method": payment_method,
                "invoice_id": invoice_id,
                "pay_password": pay_password
            ]
        }
    }
}
// MARK: - CartList
struct CartList: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: CartListDataClass
}

// MARK: - DataClass
struct CartListDataClass: Codable {
    let cart: [Cart]
    let stats: Stats
}

// MARK: - Cart
struct Cart: Codable {
    let id, pCategoryID, categoryID, name: String
    let image: String
    let productID, productOptionUnionID, optionUnionName, weight: String
    let price, quantity, shippingType, checkedFlag: String

    enum CodingKeys: String, CodingKey {
        case id
        case pCategoryID = "p_category_id"
        case categoryID = "category_id"
        case name, image
        case productID = "product_id"
        case productOptionUnionID = "product_option_union_id"
        case optionUnionName = "option_union_name"
        case weight, price, quantity
        case shippingType = "shipping_type"
        case checkedFlag = "checked_flag"
    }
}

// MARK: - Stats
struct Stats: Codable {
    let quantity: Int
    let feeMsg, feeMsgContent, total: String

    enum CodingKeys: String, CodingKey {
        case total, quantity
        case feeMsg = "fee_msg"
        case feeMsgContent = "fee_msg_content"
    }
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

struct TixianPay: Codable {
    let name: String
    let pfn: String
    let icon: String
    let binding_flag: Bool
}

// MARK: - Payment
struct Payment: Codable {
    let name, pfn: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case name, pfn
        case icon
    }

    func getIcon() -> String {
        if icon.isEmpty {
            return "https://app.necesstore.com/upload/advert/o_10530652.jpg"
        } else {
            return icon
        }
    }
}

struct SettlePayment: Codable {
    let name, pfn: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case name, pfn
        case icon
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
    let store_id: String
    let invoice: Invoice
    let payment: [SettlePayment]
//    let stores: [Store]

    enum CodingKeys: String, CodingKey {
        case products
        case redPackage = "red_package"
        case address, payment
        case shippingFee = "shipping_fee"
        case coupons, store_id, invoice
    }
}

// MARK: - Invoice
struct Invoice: Codable {
    let type, name, telephone, email: String?
    let taxNum, isDefault, id: String?

    enum CodingKeys: String, CodingKey {
        case type, name, telephone, email
        case taxNum = "tax_num"
        case isDefault = "is_default"
        case id
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

// MARK: - ChangeCart
struct ChangeCart: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: ChangeCartDataClass
}

// MARK: - DataClass
struct ChangeCartDataClass: Codable {
    let stats: Stats
}

// MARK: - ChangeCollectList
struct ChangeCollectList: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: CollectDataClass
}

// MARK: - DataClass
struct CollectDataClass: Codable {
    let products: [CollectProduct]
    let stats: CollectStats
}

// MARK: - Product
struct CollectProduct: Codable {
    let id, name, title, price: String
    let oldPrice: String
    let image: String
    let saleCnt, created, productOptionUnionID: String

    enum CodingKeys: String, CodingKey {
        case id, name, title, price
        case oldPrice = "old_price"
        case image
        case saleCnt = "sale_cnt"
        case created
        case productOptionUnionID = "product_option_union_id"
    }
}

// MARK: - Stats
struct CollectStats: Codable {
    let quantity: Int
    let feeMsg, feeMsgContent, total: String
    let diffPrice: Float

    enum CodingKeys: String, CodingKey {
        case total, quantity
        case feeMsg = "fee_msg"
        case feeMsgContent = "fee_msg_content"
        case diffPrice = "diff_price"
    }
}

// MARK: - AddInvoice
struct AddInvoice: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: InvoiceDataClass
}

// MARK: - DataClass
struct InvoiceDataClass: Codable {
    let invoice: Invoice
}

// MARK: - InvoiceInfo
struct InvoiceInfo: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: InvoiceInfoDataClass
}

// MARK: - DataClass
struct InvoiceInfoDataClass: Codable {
    let company, person: Company
    let headType: String
    let headTypes: HeadTypes
    let types: Types

    enum CodingKeys: String, CodingKey {
        case company, person
        case headType = "head_type"
        case headTypes = "head_types"
        case types
    }
}

// MARK: - Company
struct Company: Codable {
    let id, type, headType, name: String
    let telephone, email, taxNum, customerID: String
    let isDefault, created, modified: String

    enum CodingKeys: String, CodingKey {
        case id, type
        case headType = "head_type"
        case name, telephone, email
        case taxNum = "tax_num"
        case customerID = "customer_id"
        case isDefault = "is_default"
        case created, modified
    }
}

// MARK: - HeadTypes
struct HeadTypes: Codable {
    let the1, the2: String

    enum CodingKeys: String, CodingKey {
        case the1 = "1"
        case the2 = "2"
    }
}

// MARK: - Types
struct Types: Codable {
    let the1: String

    enum CodingKeys: String, CodingKey {
        case the1 = "1"
    }
}
