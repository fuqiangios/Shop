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
    let points: Int
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

