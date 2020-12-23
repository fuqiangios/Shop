//
//  Order.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/20.
//  Copyright © 2020 付强. All rights reserved.
//

import Foundation

extension API {
    struct orderList: Post {
        typealias Node = Order
        var path: String = "customer/my_order"

        let tab_status: String
        let page: String
        init(tab_status: String, page: String) {
            self.tab_status = tab_status
            self.page = page
        }

        func parameters() -> [String: Any]? {
            return ["tab_status":tab_status, "page":page]
        }
    }

    struct orderDetail: Post {
        typealias Node = OrderDetail
        var path: String = "customer/order_info"

        let orderId: String
        init(orderId: String) {
            self.orderId = orderId
        }

        func parameters() -> [String: Any]? {
            return ["order_id":orderId]
        }
    }

    struct evaluateManager: Post {
        typealias Node = Evaluate
        var path: String = "customer/my_evaluate"

        let type: String
        let page: String
        init(type: String, page: String) {
            self.type = type
            self.page = page
        }

        func parameters() -> [String: Any]? {
            return ["type":type, "page":page]
        }
    }

    struct orderUpdateStatus: Post {
        typealias Node = CartNumChange
        var path: String = "customer/update_order"

        let orderId: String
        let button_type: String
        init(orderId: String, button_type: String) {
            self.orderId = orderId
            self.button_type = button_type
        }

        func parameters() -> [String: Any]? {
            return ["order_id":orderId, "button_type": button_type]
        }
    }

    struct evaluateSubmitn: Post {
        typealias Node = CartNumChange
        var path: String = "customer/save_evaluate"

        let orderId: String
        let product_id: String
        let star: String
        let content: String
        let images: [String]
        init(orderId: String, product_id: String, star: String, content: String, images: [String]) {
            self.orderId = orderId
            self.product_id = product_id
            self.star = star
            self.content = content
            self.images = images
        }

        func parameters() -> [String: Any]? {
            return ["order_id":orderId, "product_id": product_id, "star":star, "content":content, "images":images]
        }
    }

    struct evaluateDelete: Post {
        typealias Node = CartNumChange
        var path: String = "customer/del_evaluate"

        let product_evaluate_id: String
        init(product_evaluate_id: String) {
            self.product_evaluate_id = product_evaluate_id
        }

        func parameters() -> [String: Any]? {
            return ["product_evaluate_id":product_evaluate_id]
        }
    }

    struct aftersaleList: Post {
        typealias Node = Aftersale
        var path: String = "order/aftersale_list"

        let tab_status: String
        init(tab_status: String) {
            self.tab_status = tab_status
        }

        func parameters() -> [String: Any]? {
            return ["tab_status":tab_status]
        }
    }

    struct aftersaleInfo: Post {
        

        typealias Node = AftersaleShow
        var path: String = "order/aftersale_show"

        let order_product_id: String
        init(order_product_id: String) {
            self.order_product_id = order_product_id
        }

        func parameters() -> [String: Any]? {
            return ["order_product_id": order_product_id]
        }
    }

    struct aftersaleSubmit: Post {


        typealias Node = CartNumChange
        var path: String = "order/aftersale_confirm"

        let order_product_id: String
        let aftersale_type_id: String
        let aftersale_reason_id: String
        let quantity: String
        let description: String
        let images: [String]
        let address_id: String
        init(order_product_id: String, aftersale_type_id: String, aftersale_reason_id: String, quantity: String, description: String, images: [String], address_id: String) {
            self.order_product_id = order_product_id
            self.aftersale_type_id = aftersale_type_id
            self.aftersale_reason_id = aftersale_reason_id
            self.quantity = quantity
            self.description = description
            self.images = images
            self.address_id = address_id
        }

        func parameters() -> [String: Any]? {
            return [
                "order_product_id": order_product_id,
                "aftersale_type_id": aftersale_type_id,
                "aftersale_reason_id": aftersale_reason_id,
                "quantity": quantity,
                "description": description,
                "images": images,
                "address_id": address_id
            ]
        }
    }

}

// MARK: - Order
struct Order: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: [OrderDatum]
}

// MARK: - Datum
struct OrderDatum: Codable {
    let id, orderCode, orderStatus, paymentMethod: String
    let statusName, price, quantity: String
    let products: [OrderProduct]
    let created: String

    enum CodingKeys: String, CodingKey {
        case id
        case orderCode = "order_code"
        case orderStatus = "order_status"
        case paymentMethod = "payment_method"
        case statusName = "status_name"
        case price, quantity, products, created
    }
}

// MARK: - Product
struct OrderProduct: Codable {
    let productID, name: String
    let image: String
    let price, quantity, optionUnionName, total: String
    let aftersale_flag,aftersale_id,order_product_id: String?
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case name, image, price, quantity, aftersale_flag
        case optionUnionName = "option_union_name"
        case total,order_product_id
        case aftersale_id = "order_aftersale_id"
    }
}


// MARK: - OrderDetail
struct OrderDetail: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: OrderDetailDataClass
}

// MARK: - DataClass
struct OrderDetailDataClass: Codable {
    let id, orderCode, orderStatus, customerID: String
    let paymentMethod, paymentPfn, price, total: String
    let weight, redPacket, orderType, selfStoreID: String
    let storeID, shippingName, shippingTelephone, shippingAddress: String
    let shippingPrice, shippingCompany, shippingNo, shippingCode: String
    let customerCouponID, couponContent, couponPrice, deleteFlag: String
    let amountPrice, pluginPrice, created, modified: String
    let statusName: String
    let products: [OrderProduct]
    let created_time: String
    let pay_time: String
    let shipping_time: String
    let confirm_time: String

    enum CodingKeys: String, CodingKey {
        case id
        case orderCode = "order_code"
        case orderStatus = "order_status"
        case customerID = "customer_id"
        case paymentMethod = "payment_method"
        case paymentPfn = "payment_pfn"
        case price, total, weight
        case redPacket = "red_packet"
        case orderType = "order_type"
        case selfStoreID = "self_store_id"
        case storeID = "store_id"
        case shippingName = "shipping_name"
        case shippingTelephone = "shipping_telephone"
        case shippingAddress = "shipping_address"
        case shippingPrice = "shipping_price"
        case shippingCompany = "shipping_company"
        case shippingNo = "shipping_no"
        case shippingCode = "shipping_code"
        case customerCouponID = "customer_coupon_id"
        case couponContent = "coupon_content"
        case couponPrice = "coupon_price"
        case deleteFlag = "delete_flag"
        case amountPrice = "amount_price"
        case pluginPrice = "plugin_price"
        case created, modified
        case statusName = "status_name"
        case products, created_time, pay_time, shipping_time,confirm_time
    }
}

// MARK: - Evaluate
struct Evaluate: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: [EvaluateDatum]
}

// MARK: - Datum
struct EvaluateDatum: Codable {
    let productID, orderID, name: String
    let image: String
    let price, quantity, optionUnionName: String
    let user_name, user_image, created, content, product_evaluate_id,star: String?
    let evaluate_image: [String]?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case orderID = "order_id"
        case name, image, price, quantity,user_name,user_image,created,content,star,evaluate_image, product_evaluate_id
        case optionUnionName = "option_union_name"
    }
}

// MARK: - Aftersale
struct Aftersale: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: [AftersaleDatum]
}

// MARK: - Datum
struct AftersaleDatum: Codable {
    let orderProductID, name: String
    let image: String
    let price, quantity, optionUnionName, total: String
    let orderCode, orderStatus, statusName, created: String
    let aftersale_id: String?
    let aftersale_type_name: String?
    
    enum CodingKeys: String, CodingKey {
        case orderProductID = "order_product_id"
        case name, image, price, quantity
        case optionUnionName = "option_union_name"
        case total,aftersale_type_name
        case aftersale_id
        case orderCode = "order_code"
        case orderStatus = "order_status"
        case statusName = "status_name"
        case created
    }
}

// MARK: - AftersaleShow
struct AftersaleShow: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: AftersaleShowDataClass
}

// MARK: - DataClass
struct AftersaleShowDataClass: Codable {
    let reason: [Reason]?
    let orderProduct: AftersaleShowOrderProduct?
    let orderAftersale: OrderAftersale?
    let order: AfterSaleOrder
//    let orderAftersaleImage: [String]?

    enum CodingKeys: String, CodingKey {
        case reason,order
        case orderProduct = "order_product"
        case orderAftersale = "order_aftersale"
//        case orderAftersaleImage = "order_aftersale_image"
    }
}

struct AfterSaleOrder: Codable {
    let id, orderCode, orderStatus, customerID: String
    let paymentMethod, paymentPfn, price, total: String
    let weight, redPacket, orderType, selfStoreID: String
    let storeID, shippingName, shippingTelephone, shippingAddress: String
    let shippingPrice, shippingCompany, shippingID, shippingNo: String
    let shippingCode, customerCouponID, couponContent, couponPrice: String
    let deleteFlag, amountPrice, pluginPrice, refundPrice: String
    let refundRedPacket, rrpAmountPrice, rrpFundPrice, invoiceID: String
    let invoiceType, invoiceHeadType, invoiceName, invoiceTelephone: String
    let invoiceEmail, invoiceTaxNum, outTradeNo, remarks: String
    let rrpOrderID, rrpOrderType, inviteID, created: String
    let modified,address_id: String

    enum CodingKeys: String, CodingKey {
        case id,address_id
        case orderCode = "order_code"
        case orderStatus = "order_status"
        case customerID = "customer_id"
        case paymentMethod = "payment_method"
        case paymentPfn = "payment_pfn"
        case price, total, weight
        case redPacket = "red_packet"
        case orderType = "order_type"
        case selfStoreID = "self_store_id"
        case storeID = "store_id"
        case shippingName = "shipping_name"
        case shippingTelephone = "shipping_telephone"
        case shippingAddress = "shipping_address"
        case shippingPrice = "shipping_price"
        case shippingCompany = "shipping_company"
        case shippingID = "shipping_id"
        case shippingNo = "shipping_no"
        case shippingCode = "shipping_code"
        case customerCouponID = "customer_coupon_id"
        case couponContent = "coupon_content"
        case couponPrice = "coupon_price"
        case deleteFlag = "delete_flag"
        case amountPrice = "amount_price"
        case pluginPrice = "plugin_price"
        case refundPrice = "refund_price"
        case refundRedPacket = "refund_red_packet"
        case rrpAmountPrice = "rrp_amount_price"
        case rrpFundPrice = "rrp_fund_price"
        case invoiceID = "invoice_id"
        case invoiceType = "invoice_type"
        case invoiceHeadType = "invoice_head_type"
        case invoiceName = "invoice_name"
        case invoiceTelephone = "invoice_telephone"
        case invoiceEmail = "invoice_email"
        case invoiceTaxNum = "invoice_tax_num"
        case outTradeNo = "out_trade_no"
        case remarks
        case rrpOrderID = "rrp_order_id"
        case rrpOrderType = "rrp_order_type"
        case inviteID = "invite_id"
        case created, modified
    }
}

// MARK: - OrderAftersale
struct OrderAftersale: Codable {
}

// MARK: - OrderProduct
struct AftersaleShowOrderProduct: Codable {
    let id, customerID, orderID, productID: String
    let name: String
    let image: String
    let price, quantity, productOptionUnionID, optionUnionName: String
    let weight, total, points, redPackage: String
    let evaluateFlag, aftersaleFlag, created, modified: String

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case orderID = "order_id"
        case productID = "product_id"
        case name, image, price, quantity
        case productOptionUnionID = "product_option_union_id"
        case optionUnionName = "option_union_name"
        case weight, total, points
        case redPackage = "red_package"
        case evaluateFlag = "evaluate_flag"
        case aftersaleFlag = "aftersale_flag"
        case created, modified
    }
}

// MARK: - Reason
struct Reason: Codable {
    let id, name, aftersaleTypeID, created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case aftersaleTypeID = "aftersale_type_id"
        case created
    }}

// MARK: - Logis
struct Logis: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: LogisDataClass
}

// MARK: - DataClass
struct LogisDataClass: Codable {
    let number, type: String
    let list: [LogisList]
    let deliverystatus, issign, expName, expSite: String
    let expPhone: String
    let logo: String
    let courier, courierPhone, updateTime, takeTime: String
}

// MARK: - List
struct LogisList: Codable {
    let time, status: String
}



