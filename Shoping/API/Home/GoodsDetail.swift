// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let goodsDetail = try? newJSONDecoder().decode(GoodsDetail.self, from: jsonData)

import Foundation

extension API {
    struct goodsDetailData: Post {
        typealias Node = GoodsDetail
        var path: String = "product/info"

        let product_id: String
        init(product_id: String) {
            self.product_id = product_id
        }

        func parameters() -> [String: Any]? {
            return [
                "product_id": product_id
            ]
        }
    }

    struct receiveCoupon: Post {
        typealias Node = CartNumChange
        var path: String = "product/receive_coupon"

        let coupon_id: String
        init(coupon_id: String) {
            self.coupon_id = coupon_id
        }

        func parameters() -> [String: Any]? {
            return [
                "coupon_id": coupon_id
            ]
        }
    }

    struct addCart: Post {
        typealias Node = AddCart
        var path: String = "product/add_cart"

        let product_id: String
        let quantity: String
        let product_option_union_id: String
        init(product_id: String, quantity: String, product_option_union_id: String) {
            self.product_id = product_id
            self.quantity = quantity
            self.product_option_union_id = product_option_union_id
        }

        func parameters() -> [String: Any]? {
            return [
                "product_id": product_id,
                "quantity": quantity,
                "product_option_union_id": product_option_union_id
            ]
        }
    }

    struct evaluateList: Post {
        typealias Node = GoodsEvaluateList
        var path: String = "product/product_evaluate"

        let product_id: String
        let page: String
        init(product_id: String, page: String) {
            self.product_id = product_id
            self.page = page
        }

        func parameters() -> [String: Any]? {
            return [
                "product_id": product_id,
                "page": page
            ]
        }
    }
}

// MARK: - GoodsDetail
struct GoodsDetail: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: GoodsDataClass
}

struct GoodsEvaluateList: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: [ProductEvaluate]
}

struct ProductRelation: Codable {
    let name: String
    let id: String
    let image: String
    let price: String
    let title: String
}

// MARK: - DataClass
struct GoodsDataClass: Codable {
    let product: GoodsProduct
    let productImage: [ProductImage]
    let productOptionGroup: [ProductOptionGroup]
    let union: [Union]
    let productEvaluate: [ProductEvaluate]
    let productModel: [ProductModel]
    let coupon: [Coupon]
    let address: GoodsAddress
    let invite_code: String
    let product_relation: [ProductRelation]

    enum CodingKeys: String, CodingKey {
        case product
        case productImage = "product_image"
        case productOptionGroup = "product_option_group"
        case union, address
        case productEvaluate = "product_evaluate"
        case productModel = "product_model"
        case coupon = "coupon"
        case invite_code
        case product_relation
    }

    func getProductOptionGroup() -> [ProductOptionGroup] {
        if productOptionGroup.count == 0 {
            return [ProductOptionGroup(id: "", name: "", productOption: []),ProductOptionGroup(id: "", name: "", productOption: [])]
        } else if productOptionGroup.count == 1 {
            return [(productOptionGroup.first ?? ProductOptionGroup(id: "", name: "", productOption: [])),ProductOptionGroup(id: "", name: "", productOption: [])]
        } else {
            return productOptionGroup
        }

    }
}

// MARK: - ProductModel
struct ProductModel: Codable {
    let key, value: String
}

// MARK: - Coupon
struct Coupon: Codable {
    let id, name, detail, couponDescription: String
    let couponType, faceValue, useableValue, validityType: String
    let startTime, endTime, days, takeCnt: String
    let useCnt, categoryIDS, productIDS, created: String
    let modified: String
    let hasReceive: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, detail
        case couponDescription = "description"
        case couponType = "coupon_type"
        case faceValue = "face_value"
        case useableValue = "useable_value"
        case validityType = "validity_type"
        case startTime = "start_time"
        case endTime = "end_time"
        case days
        case takeCnt = "take_cnt"
        case useCnt = "use_cnt"
        case categoryIDS = "category_ids"
        case productIDS = "product_ids"
        case created, modified
        case hasReceive = "has_receive"
    }
}

// MARK: - Address
struct GoodsAddress: Codable {
    let id, customerID, name, telephone: String?
    let address, detail, isDefault, created: String?
    let modified: String?

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case name, telephone, address, detail
        case isDefault = "is_default"
        case created, modified
    }
}

// MARK: - Product
struct GoodsProduct: Codable {
    let id, name, code, pCategoryID: String
    let categoryID, price, oldPrice, productDescription: String
    let weight, stock, points, zanCnt: String
    let shareCnt, saleCnt, sort, status: String
    let labelIDS, created, modified: String
    let image: String
    let mixPrice, maxPrice: String
    let hasCollection: Bool
    let returncontent: String
    let shippingcontent: String
    let recommendcontent: String
    let evaluate_good_per: String?
    let evaluate_count: Int?
    let activity_flag: String
    let video: String
    let activity_image_1: String
    let activity_image_2: String
    let activity_image_3: String

    enum CodingKeys: String, CodingKey {
        case id, name, code, activity_flag, video, activity_image_1, activity_image_2, activity_image_3
        case pCategoryID = "p_category_id"
        case categoryID = "category_id"
        case price, evaluate_good_per, evaluate_count
        case recommendcontent = "recommend_content"
        case shippingcontent = "shipping_content"
        case returncontent = "return_content"
        case oldPrice = "old_price"
        case productDescription = "description"
        case weight, stock, points
        case zanCnt = "zan_cnt"
        case shareCnt = "share_cnt"
        case saleCnt = "sale_cnt"
        case sort, status
        case labelIDS = "label_ids"
        case created, modified, image
        case mixPrice = "mix_price"
        case maxPrice = "max_price"
        case hasCollection = "has_collection"
    }
}

// MARK: - ProductEvaluate
struct ProductEvaluate: Codable {
    let id, star, content, created: String
    let userImage, userName: String
    let evaluateImage: [String]
    let evaluateReply: [EvaluateReply]

    enum CodingKeys: String, CodingKey {
        case id, star, content, created
        case userImage = "user_image"
        case userName = "user_name"
        case evaluateImage = "evaluate_image"
        case evaluateReply = "evaluate_reply"
    }
    func getUserImage() -> String {
        if userImage.isEmpty {
            return "https://app.necesstore.com/upload/advert/o_10530652.jpg"
        }
        return userImage
    }
}

// MARK: - EvaluateReply
struct EvaluateReply: Codable {
    let content, created, userImage, userName: String

    enum CodingKeys: String, CodingKey {
        case content, created
        case userImage = "user_image"
        case userName = "user_name"
    }
}

// MARK: - ProductImage
struct ProductImage: Codable {
    let id, productID, sort, created: String
    let modified: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case sort, created, modified, image
    }
}

// MARK: - ProductOptionGroup
struct ProductOptionGroup: Codable {
    let id, name: String
    let productOption: [ProductOption]

    enum CodingKeys: String, CodingKey {
        case id, name
        case productOption = "product_option"
    }
}

// MARK: - ProductOption
struct ProductOption: Codable {
    let id, name, image: String
}

// MARK: - Union
struct Union: Codable {
    let id, productID, productUnion, productUnionName: String
    let barCode, stock, weight, price: String
    let oldPrice, created, modified: String

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case productUnion = "product_union"
        case productUnionName = "product_union_name"
        case barCode = "bar_code"
        case stock, weight, price
        case oldPrice = "old_price"
        case created, modified
    }
}

// MARK: - AddCart
struct AddCart: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: AddCartDataClass
}

// MARK: - DataClass
struct AddCartDataClass: Codable {
    let id, productID, customerID, productOptionUnionID, optionUnionName: String?
    let weight, price: String?
    let stats: CollectStats

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case productID = "product_id"
        case customerID = "customer_id"
        case productOptionUnionID = "product_option_union_id"
        case optionUnionName = "option_union_name"
        case weight, price, stats
    }
}
