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
        let yaoqing: String
        init(type: String, password: String, telephone: String?, code: String?,
             email: String?, yaoqing: String) {
            self.type = type
            self.password = password
            self.telephone = telephone
            self.code = code
            self.email = email
            self.yaoqing = yaoqing
        }
        func parameters() -> [String: Any]? {
            return [
                "type": type,
                "password": password,
                "telephone": telephone ?? "",
                "code": code ?? "",
                "email": email ?? "",
                "invite_code": yaoqing,
             ]
        }
    }

    struct amountPut: Post {
        typealias Node = PointPut
        var path: String = "customer/my_point_turn_show"

        let type: String
        init(type: String) {
            self.type = type
        }

    func parameters() -> [String: Any]? {
        return [
            "type": type,
         ]
    }
    }

    struct getCode: Post {
        typealias Node = CartNumChange
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

    struct bindEmail: Post {
        typealias Node = CartNumChange
        var path: String = "customer/binding_email"


        let email: String
        init(email: String) {
            self.email = email
        }

        func parameters() -> [String: Any]? {
            return [
                "email": email
             ]
        }
    }

    struct verfiPhoneCode: Post {
        typealias Node = CartNumChange
        var path: String = "customer/verify_telephone"

        let code: String
        let telephone: String
        init(telephone: String, code: String) {
            self.telephone = telephone
            self.code = code
        }

        func parameters() -> [String: Any]? {
            return [
                "telephone": telephone,
                "code": code
             ]
        }
    }

    struct bindPhoneCode: Post {
        typealias Node = CartNumChange
        var path: String = "customer/binding_telephone"

        let code: String
        let telephone: String
        init(telephone: String, code: String) {
            self.telephone = telephone
            self.code = code
        }

        func parameters() -> [String: Any]? {
            return [
                "telephone": telephone,
                "code": code
             ]
        }
    }

    struct getUserInfo: Post {
        typealias Node = UserInfo
        var path: String = "customer/user_info"


        init() {
        }

        func parameters() -> [String: Any]? {
            return [
                "": ""
             ]
        }
    }

    struct updateUserInfo: Post {
        typealias Node = CartNumChange
        var path: String = "customer/update_user"
        let name: String
        let image: String
        let sex: String
        let birthday: String
        init(name: String, image: String, sex: String, birthday: String) {
            self.name = name
            self.image = image
            self.sex = sex
            self.birthday = birthday
        }

        func parameters() -> [String: Any]? {
            return [
                "name": name,
                "image": image,
                "sex": sex,
                "birthday": birthday
             ]
        }
    }

    struct fansInfo: Post {
        typealias Node = FansData
        var path: String = "customer/my_fans"


        let name: String
        let telephone: String
        init(name: String, telephone: String) {
            self.name = name
            self.telephone = telephone
        }

        func parameters() -> [String: Any]? {
            return [
                "telephone": telephone,
                "name": name
             ]
        }
    }

    struct couponData: Post {
        typealias Node = CouponList
        var path: String = "customer/my_coupons"


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

    struct mineData: Post {
        typealias Node = MineInfo
        var path: String = "customer/my_page"

        init() {
        }

        func parameters() -> [String: Any]? {
            return [
                "": ""
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

    struct achievementData: Post {
        typealias Node = Achievement
        var path: String = "customer/performance_show"

        init() {
        }

        func parameters() -> [String: Any]? {
            return [
                "": ""
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

    struct bindAlipay: Post {
        typealias Node = CartNumChange
        var path: String = "customer/alipay_info"

        let alipay_name: String
        let alipay_identity: String
        init(alipay_name: String, alipay_identity: String) {
            self.alipay_name = alipay_name
            self.alipay_identity = alipay_identity
        }

        func parameters() -> [String: Any]? {
            return [
                "alipay_name": alipay_name,
                "alipay_identity": alipay_identity
             ]
        }
    }

    struct bindWechat: Post {
        typealias Node = CartNumChange
        var path: String = "customer/wxpay_info"

        let name: String
        let openid: String
        init(name: String, openid: String) {
            self.name = name
            self.openid = openid
        }

        func parameters() -> [String: Any]? {
            return [
                "wx_name": name,
                "wx_openid": openid
             ]
        }
    }

    struct pointInfoList: Post {
        typealias Node = PointList
        var path: String = "customer/my_points_list"
        let start_date: String
        let end_date: String
        let page: String
        let type: String
        init(start_date: String, end_date: String,page:String, type: String ) {
            self.start_date = start_date
            self.end_date = end_date
            self.page = page
            self.type = type
        }

        func parameters() -> [String: Any]? {
            return [
                "month": start_date,
                "end_date": end_date,
                "page": page,
                "type": type
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
        let amount: String
        let type: String
        let payment_pfn: String

        init(amount: String, type: String, payment_pfn: String) {
            self.amount = amount
            self.type = type
            self.payment_pfn = payment_pfn
        }

        func parameters() -> [String: Any]? {
            return [
                "amount": amount,
                "type": type,
                "payment_pfn": payment_pfn
             ]
        }
    }

    struct fansListData: Post {
        typealias Node = FansList
        var path: String = "customer/my_fans_order_list"
        let user_token: String
        let month: String
        let page: String

        init(user_token: String, month: String, page: String) {
            self.user_token = user_token
            self.month = month
            self.page = page
        }

        func parameters() -> [String: Any]? {
            return [
                "user_token": user_token,
                "month": month,
                "page": page
             ]
        }
    }

    struct deleteFavorite: Post {
        typealias Node = CartNumChange
        var path: String = "customer/my_collection_del"
        let ids: [String]

        init(ids: [String]) {
            self.ids = ids
        }

        func parameters() -> [String: Any]? {
            return [
                "ids": ids,
             ]
        }
    }

    struct amountList: Post {
        typealias Node = AmountList
        var path: String = "customer/my_amount_list"
        let type: String

        let page: String
        init(type: String, page:String ) {
            self.type = type
            self.page = page
        }

        func parameters() -> [String: Any]? {
            return [
                "type": type,
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

    struct getAftersaleDetail: Post {
        typealias Node = AfterDetail
        var path: String = "order/aftersale_info"

        let aftersale_id: String
        init(aftersale_id: String) {
            self.aftersale_id = aftersale_id
        }

        func parameters() -> [String: Any]? {
            return [
                "aftersale_id": aftersale_id,
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

    struct getOrderPay: Post {
        typealias Node = Chongzhi
        var path: String = "order/pay"
        let order_id: String
        let payment_pfn: String

        init(order_id: String, payment_pfn: String) {
            self.order_id = order_id
            self.payment_pfn = payment_pfn
        }

        func parameters() -> [String: Any]? {
            return [
                "order_id": order_id,
                "payment_pfn": payment_pfn
             ]
        }
    }

    struct redpackgeList: Post {
        typealias Node = RedPackegList
        var path: String = "customer/my_redpackage_list"

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

    struct achievementInfo: Post {
        typealias Node = AchievementInfo
        var path: String = "customer/performance_query"

        let store_id: String
        init(store_id: String) {
            self.store_id = store_id
        }

        func parameters() -> [String: Any]? {
            return [
                "store_id": store_id
             ]
        }
    }

    struct redpackgData: Post {
        typealias Node = RedPackeg
        var path: String = "customer/my_redpackage"

        init() {
        }

        func parameters() -> [String: Any]? {
            return [
                "": ""
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

    struct retrospectData: Post {
        typealias Node = Retrospect
        var path: String = "product/product_source"

        let product_code: String
        init(product_code: String) {
            self.product_code = product_code
        }

        func parameters() -> [String: Any]? {
            return [
                "product_code": product_code
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
                "user_name": telephone ?? "",
                "login_type": login_type,
                "email": email ?? "",
                "password": password ?? "",
                "code": wx_openid ?? "",
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
    let data: Tk
}

struct Tk: Codable {
    let user_token: String

}

struct UserToken: Codable {
    let result: Bool
    let message: String
    let data: TokenDataClass
}

struct TokenDataClass: Codable {
    let user_token: String
    enum CodingKeys: String, CodingKey {
        case user_token
    }
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
    let pointUnit: String
    let points_list: [PointItem]

    enum CodingKeys: String, CodingKey {
        case points
        case pointUnit = "point_unit"
        case points_list
    }
}

// MARK: - PointItem
struct PointItem: Codable {
    let method: String
    let incomeFlag: Bool
    let value, created: String

    enum CodingKeys: String, CodingKey {
        case method
        case incomeFlag = "income_flag"
        case value, created
    }
}

struct RedPackegList: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: RedPackegListDataClass
}

// MARK: - DataClass
struct RedPackegListDataClass: Codable {
    let redPackageList: [RedPackageList]

    enum CodingKeys: String, CodingKey {
        case redPackageList = "red_package_list"
    }
}

// MARK: - RedPackeg
struct RedPackeg: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: RedPackegDataClass
}

// MARK: - DataClass
struct RedPackegDataClass: Codable {
    let redPackageList: [RedPackageList]
    let income, pay, redPackage: String

    enum CodingKeys: String, CodingKey {
        case redPackageList = "red_package_list"
        case income, pay
        case redPackage = "red_package"
    }
}

// MARK: - RedPackageList
struct RedPackageList: Codable {
    let method: String
    let incomeFlag: Bool?
    let endDate, created: String
    let value: String?

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
    let amount: String
    let amountList: [AmountItemList]

    enum CodingKeys: String, CodingKey {
        case amount
        case amountList = "amount_list"
    }
}

// MARK: - AmountList
struct AmountItemList: Codable {
    let method: String
    let incomeFlag: Bool
    let value, created: String

    enum CodingKeys: String, CodingKey {
        case method
        case incomeFlag = "income_flag"
        case value, created
    }
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
    let amountList: [AmountItemList]

    enum CodingKeys: String, CodingKey {
        case amountList = "amount_list"
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

// MARK: - DataClass
struct PayOrderDataClass: Codable {
    let res: Bool
    let plugin: String
    let order_id: String
}

// MARK: - Chongzhi
struct PayOrder: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: PayOrderDataClass
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
    let productID, name, id: String
    let image: String
    let price: String
    let union_option_name: String
    let product_option_union_id: String

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case name, image, price, union_option_name, product_option_union_id, id
    }
}

struct MineInfo: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: MineInfoDataClass
}

// MARK: - DataClass
struct MineInfoDataClass: Codable {
    let id, name, image, trueName: String
    let telephone, email, wxOpenid, staticPoints: String
    let shortPoints, amount, redPackage, userToken: String
    let isBlack, inviteID, inviteCount, settleCode: String
    let totalCost, created, modified: String
    let couponCount: Int

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case trueName = "true_name"
        case telephone, email
        case wxOpenid = "wx_openid"
        case staticPoints = "static_points"
        case shortPoints = "short_points"
        case amount
        case redPackage = "red_package"
        case userToken = "user_token"
        case isBlack = "is_black"
        case inviteID = "invite_id"
        case inviteCount = "invite_count"
        case settleCode = "settle_code"
        case totalCost = "total_cost"
        case created, modified
        case couponCount = "coupon_count"
    }
}

// MARK: - PointPut
struct PointPut: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: PointPutDataClass
}

// MARK: - DataClass
struct PointPutDataClass: Codable {
    let pointUnit, amount: String
    let payment: [TixianPay]

    enum CodingKeys: String, CodingKey {
        case pointUnit = "point_unit"
        case amount, payment
    }
}

// MARK: - CouponList
struct CouponList: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: CouponListDataClass
}

// MARK: - DataClass
struct CouponListDataClass: Codable {
    let couponList: [CouponListElement]
    let count: Int

    enum CodingKeys: String, CodingKey {
        case couponList = "coupon_list"
        case count
    }
}

// MARK: - CouponListElement
struct CouponListElement: Codable {
    let name, detail, faceValue, unit: String
    let startTime, endTime: String

    enum CodingKeys: String, CodingKey {
        case name, detail
        case faceValue = "face_value"
        case unit
        case startTime = "start_time"
        case endTime = "end_time"
    }
}

// MARK: - Achievement
struct Achievement: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: AchievementDataClass
}

// MARK: - DataClass
struct AchievementDataClass: Codable {
    let number, total: String
    let tree: [Tree]
}

// MARK: - Tree
struct Tree: Codable {
    let region: Region
    let city: [City]

    enum CodingKeys: String, CodingKey {
        case region = "Region"
        case city = "City"
    }
}

// MARK: - City
struct City: Codable {
    let id, name, level, zoneCode: String
    let parentID, created, modified: String
    let store: [AchievementStore]

    enum CodingKeys: String, CodingKey {
        case id, name, level
        case zoneCode = "zone_code"
        case parentID = "parent_id"
        case created, modified
        case store = "Store"
    }
}

// MARK: - Store
struct AchievementStore: Codable {
    let id, name, code, regionID: String
    let cityID, detail, telephone, openTime: String
    let longitude, latitude, status, adminID: String
    let created, modified, image: String

    enum CodingKeys: String, CodingKey {
        case id, name, code
        case regionID = "region_id"
        case cityID = "city_id"
        case detail, telephone
        case openTime = "open_time"
        case longitude, latitude, status
        case adminID = "admin_id"
        case created, modified, image
    }
}

// MARK: - Region
struct Region: Codable {
    let id, name, level, zoneCode: String
    let parentID, created, modified: String

    enum CodingKeys: String, CodingKey {
        case id, name, level
        case zoneCode = "zone_code"
        case parentID = "parent_id"
        case created, modified
    }
}

// MARK: - AchievementInfo
struct AchievementInfo: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: AchievementInfoDataClass
}

// MARK: - DataClass
struct AchievementInfoDataClass: Codable {
    let yesTotal, nowMonthTotal, lastMonthTotal, yearTotal: String
    let number: String

    enum CodingKeys: String, CodingKey {
        case yesTotal = "yes_total"
        case nowMonthTotal = "now_month_total"
        case lastMonthTotal = "last_month_total"
        case yearTotal = "year_total"
        case number
    }
}

// MARK: - Retrospect
struct Retrospect: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: RetrospectDataClass
}

// MARK: - DataClass
struct RetrospectDataClass: Codable {
    let product: RetrospectProduct
    let storeProduct: [StoreProduct]

    enum CodingKeys: String, CodingKey {
        case product
        case storeProduct = "store_product"
    }
}

// MARK: - Product
struct RetrospectProduct: Codable {
    let id, categoryID, pCategoryID, name: String
    let title, code, price, stock: String
    let saleCnt, created: String
    let image: String
    let pCategoryName, categoryName: String

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case pCategoryID = "p_category_id"
        case name, title, code, price, stock
        case saleCnt = "sale_cnt"
        case created, image
        case pCategoryName = "p_category_name"
        case categoryName = "category_name"
    }
}

// MARK: - StoreProduct
struct StoreProduct: Codable {
    let name, stock, productName, updateTime: String
    let region, city: String

    enum CodingKeys: String, CodingKey {
        case name, stock
        case productName = "product_name"
        case updateTime = "update_time"
        case region, city
    }
}

// MARK: - FansData
struct FansData: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: FansDataDataClass
}

// MARK: - DataClass
struct FansDataDataClass: Codable {
    let inviteCount, todayInviteCount: String
    let inviteList: [InviteList]

    enum CodingKeys: String, CodingKey {
        case inviteCount = "invite_count"
        case todayInviteCount = "today_invite_count"
        case inviteList = "invite_list"
    }
}

// MARK: - InviteList
struct InviteList: Codable {
    let id, name, inviteCount, created: String
    let redPackage, points, amount, user_token: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case inviteCount = "invite_count"
        case created
        case user_token
        case redPackage = "red_package"
        case points, amount
    }
}

// MARK: - FansList
struct FansList: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: FansListDataClass
}

// MARK: - DataClass
struct FansListDataClass: Codable {
    let orderList: [OrderList]

    enum CodingKeys: String, CodingKey {
        case orderList = "order_list"
    }
}

// MARK: - OrderList
struct OrderList: Codable {
    let price, orderCode, created, pointSave: String
    let redpackageSave, commissionSave: String

    enum CodingKeys: String, CodingKey {
        case price
        case orderCode = "order_code"
        case created
        case pointSave = "point_save"
        case redpackageSave = "redpackage_save"
        case commissionSave = "commission_save"
    }
}

// MARK: - UserInfo
struct UserInfo: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: UserInfoDataClass
}

// MARK: - DataClass
struct UserInfoDataClass: Codable {
    let id, name, image, trueName: String
    let sex, birthday, telephone, email: String
    let wxOpenid, staticPoints, shortPoints, amount: String
    let redPackage, userToken, isBlack, inviteID: String
    let inviteCount, inviteCode, settleCode, totalCost: String
    let storeID, alipayName, alipayIdentity, created: String
    let modified: String

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case trueName = "true_name"
        case sex, birthday, telephone, email
        case wxOpenid = "wx_openid"
        case staticPoints = "static_points"
        case shortPoints = "short_points"
        case amount
        case redPackage = "red_package"
        case userToken = "user_token"
        case isBlack = "is_black"
        case inviteID = "invite_id"
        case inviteCount = "invite_count"
        case inviteCode = "invite_code"
        case settleCode = "settle_code"
        case totalCost = "total_cost"
        case storeID = "store_id"
        case alipayName = "alipay_name"
        case alipayIdentity = "alipay_identity"
        case created, modified
    }
}


// MARK: - AfterDetail
struct AfterDetail: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: AfterDetailDataClass
}

// MARK: - DataClass
struct AfterDetailDataClass: Codable {
    let orderProduct: AfterDetailOrderProduct
    let afterSale: AfterSale
    let address: AfterDetailAddress

    enum CodingKeys: String, CodingKey {
        case orderProduct = "order_product"
        case afterSale = "after_sale"
        case address
    }
}

// MARK: - Address
struct AfterDetailAddress: Codable {
    let address, userName, telephone: String

    enum CodingKeys: String, CodingKey {
        case address
        case userName = "user_name"
        case telephone
    }
}

// MARK: - AfterSale
struct AfterSale: Codable {
    let id, orderProductID, aftersaleStatus, aftersaleTypeID: String
    let aftersaleTypeName, aftersaleReasonID, aftersaleReasonName, quantity: String
    let afterSaleDescription, address, userName, telephone: String
    let shippingCompany, shippingNo, customerID, created: String
    let modified, statusName: String

    enum CodingKeys: String, CodingKey {
        case id
        case orderProductID = "order_product_id"
        case aftersaleStatus = "aftersale_status"
        case aftersaleTypeID = "aftersale_type_id"
        case aftersaleTypeName = "aftersale_type_name"
        case aftersaleReasonID = "aftersale_reason_id"
        case aftersaleReasonName = "aftersale_reason_name"
        case quantity
        case afterSaleDescription = "description"
        case address
        case userName = "user_name"
        case telephone
        case shippingCompany = "shipping_company"
        case shippingNo = "shipping_no"
        case customerID = "customer_id"
        case created, modified
        case statusName = "status_name"
    }
}

// MARK: - OrderProduct
struct AfterDetailOrderProduct: Codable {
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
