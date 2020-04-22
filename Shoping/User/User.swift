//
//  User.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/18.
import Foundation

extension API {
    struct register: Post {
        typealias Node = registerStatus
        var path: String = "customer/register"

        let type: String
        let password: String
        let telephone: String?
        let code: String?
        let email: String?
        init(type: String, password: String, telephone: String?, code: String?, email: String?) {
            self.type = type
            self.password = password
            self.telephone = telephone
            self.code = code
            self.email = email
        }

        func parameters() -> [String: Any]? {
            return [
                "type": type,
                "password": password,
                "telephone": telephone ?? "",
                "code": code ?? "",
                "email": email ?? ""
             ]
        }
    }

    struct getCode: Post {
        typealias Node = registerStatus
        var path: String = "customer/getidentifying"


        let telephone: String
        init(telephone: String) {
            self.telephone = telephone
        }

        func parameters() -> [String: Any]? {
            return [
                "telephone": telephone
             ]
        }
    }

    struct uploadImg: Post {
        typealias Node = CartNumChange
        var path: String = "front/image_up"


        let telephone: String
        init(telephone: String) {
            self.telephone = telephone
        }

        func parameters() -> [String: Any]? {
            return [
                "telephone": telephone
             ]
        }
    }

    struct pointInfo: Post {
        typealias Node = Point
        var path: String = "customer/my_points"

        init() {
        }

        func parameters() -> [String: Any]? {
            return [
                "": ""
             ]
        }
    }

    struct pointInfoList: Post {
        typealias Node = PointList
        var path: String = "customer/my_points_list"
        let start_date: String
        let end_date: String
        let page: String
        init(start_date: String, end_date: String,page:String ) {
            self.start_date = start_date
            self.end_date = end_date
            self.page = page
        }

        func parameters() -> [String: Any]? {
            return [
                "start_date": start_date,
                "end_date": end_date,
                "page": page,
             ]
        }
    }

    struct pointPayPage: Post {
        typealias Node = PointPayPage
        var path: String = "customer/my_point_turn_show"

        init() {
        }

        func parameters() -> [String: Any]? {
            return [
                "": "",
             ]
        }
    }

    struct pointPay: Post {
        typealias Node = CartNumChange
        var path: String = "customer/my_point_turn_out"
        let point: String
        let type: String

        init(point: String, type: String) {
            self.point = point
            self.type = type
        }

        func parameters() -> [String: Any]? {
            return [
                "points": point,
                "type": type
             ]
        }
    }

    struct amountList: Post {
        typealias Node = AmountList
        var path: String = "customer/my_amount_list"
        let start_date: String
        let end_date: String
        let page: String
        init(start_date: String, end_date: String,page:String ) {
            self.start_date = start_date
            self.end_date = end_date
            self.page = page
        }

        func parameters() -> [String: Any]? {
            return [
                "start_date": start_date,
                "end_date": end_date,
                "page": page,
             ]
        }
    }

    struct favoriteList: Post {
        typealias Node = FavoriteList
        var path: String = "customer/my_collection"
        let page: String
        init(page:String) {
            self.page = page
        }

        func parameters() -> [String: Any]? {
            return [
                "page": page,
             ]
        }
    }

    struct chongzhiPage: Post {
        typealias Node = ChongzhiPage
        var path: String = "customer/recharge_show"

        init() {
        }

        func parameters() -> [String: Any]? {
            return [
                "": "",
             ]
        }
    }

    struct chongzhi: Post {
        typealias Node = Chongzhi
        var path: String = "customer/recharge"
        let price: String
        let payment_pfn: String

        init(price: String, payment_pfn: String) {
            self.price = price
            self.payment_pfn = payment_pfn
        }

        func parameters() -> [String: Any]? {
            return [
                "price": price,
                "payment_pfn": payment_pfn
             ]
        }
    }

    struct redpackgeList: Post {
        typealias Node = Redpackge
        var path: String = "customer/my_redpackage"

        let type: String
        init(type: String) {
            self.type = type
        }

        func parameters() -> [String: Any]? {
            return [
                "type": type
             ]
        }
    }

    struct favorite: Post {
        typealias Node = Favorite
        var path: String = "product/product_collection"

        let product_id: String
        let product_option_union_id: String
        init(product_id: String, product_option_union_id: String) {
            self.product_id = product_id
            self.product_option_union_id = product_option_union_id
        }

        func parameters() -> [String: Any]? {
            return [
                "product_id": product_id,
                "product_option_union_id": product_option_union_id
             ]
        }
    }

    struct amountInfo: Post {
        typealias Node = Amount
        var path: String = "customer/my_amount"

        init() {
        }

        func parameters() -> [String: Any]? {
            return [
                "": ""
             ]
        }
    }

    struct login: Post {
        typealias Node = UserToken
        var path: String = "/customer/login"

        let login_type: String
        let telephone: String?
        let email: String?
        let password: String?
        let wx_openid: String?
        let name: String?
        let image: String?
        init(telephone: String?, login_type: String, email: String?, password: String?, wx_openid: String?, name: String?, image: String?) {
            self.telephone = telephone
            self.login_type = login_type
            self.email = email
            self.password = password
            self.wx_openid = wx_openid
            self.name = name
            self.image = image
        }

        func parameters() -> [String: Any]? {
            return [
                "telephone": telephone ?? "",
                "login_type": login_type,
                "email": email ?? "",
                "password": password ?? "",
                "wx_openid": wx_openid ?? "",
                "name": name ?? "",
                "image": image ?? ""
             ]
        }
    }
}

// MARK: - GoodsDetail
struct registerStatus: Codable {
    let result: Bool
    let message: String
    let status: Int
}

struct UserToken: Codable {
    let result: Bool
    let message: String
    let data: TokenDataClass
}

struct TokenDataClass: Codable {
    let user_token: String
}

// MARK: - Point
struct Point: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: PointDataClass
}

// MARK: - DataClass
struct PointDataClass: Codable {
    let points: Float
    let pointUnit, content: String

    enum CodingKeys: String, CodingKey {
        case points
        case pointUnit = "point_unit"
        case content
    }
}

// MARK: - Redpackge
struct Redpackge: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: RedpackgeDataClass
}

// MARK: - DataClass
struct RedpackgeDataClass: Codable {
    let redPackageList: [RedPackageList]
    let redPackage: String

    enum CodingKeys: String, CodingKey {
        case redPackageList = "red_package_list"
        case redPackage = "red_package"
    }
}

// MARK: - RedPackageList
struct RedPackageList: Codable {
    let method: String
    let incomeFlag: Bool
    let value, endDate, created: String

    enum CodingKeys: String, CodingKey {
        case method
        case incomeFlag = "income_flag"
        case value
        case endDate = "end_date"
        case created
    }
}

// MARK: - Amount
struct Amount: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: AmountDataClass
}

// MARK: - DataClass
struct AmountDataClass: Codable {
    let amount, content: String
}

struct PointList: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: PointListDataClass
}

// MARK: - DataClass
struct PointListDataClass: Codable {
    let pointsList: [PointsList]
    let income, pay: String

    enum CodingKeys: String, CodingKey {
        case pointsList = "points_list"
        case income, pay
    }
}

// MARK: - PointsList
struct PointsList: Codable {
    let method: String
    let incomeFlag: Bool
    let value, created: String

    enum CodingKeys: String, CodingKey {
        case method
        case incomeFlag = "income_flag"
        case value, created
    }
}

struct PointPayPage: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: PointPayDataClass
}

// MARK: - DataClass
struct PointPayDataClass: Codable {
    let staticPoints, shortPoints, pointUnit, content: String

    enum CodingKeys: String, CodingKey {
        case staticPoints = "static_points"
        case shortPoints = "short_points"
        case pointUnit = "point_unit"
        case content
    }
}
// MARK: - AmountList
struct AmountList: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: AmountListDataClass
}

// MARK: - DataClass
struct AmountListDataClass: Codable {
    let amountList: [AmountListElement]
    let income, pay: String

    enum CodingKeys: String, CodingKey {
        case amountList = "amount_list"
        case income, pay
    }
}

// MARK: - AmountListElement
struct AmountListElement: Codable {
    let method: String
    let incomeFlag: Bool
    let value, created: String

    enum CodingKeys: String, CodingKey {
        case method
        case incomeFlag = "income_flag"
        case value, created
    }
}

// MARK: - ChongzhiPage
struct ChongzhiPage: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: ChongzhiDataClass
}

// MARK: - DataClass
struct ChongzhiDataClass: Codable {
    let payment: [ChongzhiPayment]
    let amount: String
}

// MARK: - Payment
struct ChongzhiPayment: Codable {
    let id, name, type, pfn: String
    let status, paymentDescription, sort, created: String
    let modified: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, name, type, pfn, status
        case paymentDescription = "description"
        case sort, created, modified, icon
    }
}

// MARK: - Chongzhi
struct Chongzhi: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: ChongzhDataClass
}

// MARK: - DataClass
struct ChongzhDataClass: Codable {
    let res: Bool
    let plugin: String
}

// MARK: - Favorite
struct Favorite: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: FavoriteDataClass
}

// MARK: - DataClass
struct FavoriteDataClass: Codable {
    let hasCollection: Bool

    enum CodingKeys: String, CodingKey {
        case hasCollection = "has_collection"
    }
}
// MARK: - FavoriteList
struct FavoriteList: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: [FavoriteListDatum]
}

// MARK: - Datum
struct FavoriteListDatum: Codable {
    let productID, name: String
    let image: String
    let price: String
    let count: Int
    let union_option_name: String

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case name, image, price, count, union_option_name
    }
}




