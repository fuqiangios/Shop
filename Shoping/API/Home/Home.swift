//
//  HomeModel.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/15.
//  Copyright © 2020 付强. All rights reserved.
//

import Foundation

extension API {
    struct homeData: Post {
        typealias Node = Home
        var path: String = "front/home"
        let longitude: String
        let latitude: String
        init(longitude: String, latitude: String) {
            self.latitude = latitude
            self.longitude = longitude
        }
        func parameters() -> [String: Any]? {
            return [
                "latitude": latitude,
                "longitude": longitude
            ]
        }
    }

    struct searchData: Post {
        typealias Node = Search
        var path: String = "front/hot_search"

        init() {
        }
        func parameters() -> [String: Any]? {
            return [
                "": "",
            ]
        }
    }

    struct homeCategoryData: Post {
        typealias Node = CategoryList
        var path: String = "front/product_list"

        let p_category_id: String?
        let category_id: String?
        let order: String?
        let key_word: String?
        let product_ids: String?
        let page: String?
        let label_code: String?
        let label_id: String?
        init(p_category_id: String?, category_id: String?, order: String? = nil, key_word: String? = nil,product_ids: String? = nil, page: String? = nil, label_code: String? = nil, label_id: String? = nil) {
            self.p_category_id = p_category_id
            self.category_id = category_id
            self.order = order
            self.key_word = key_word
            self.product_ids = product_ids
            self.page = page
            self.label_code = label_code
            self.label_id = label_id
        }

        func parameters() -> [String: Any]? {
            return [
                "p_category_id": p_category_id ?? "",
                "category_id": category_id ?? "",
                "order": order ?? "",
                "key_word": key_word ?? "",
                "product_ids": product_ids ?? "",
                "page": page ?? "",
                "label_code": label_code ?? "",
                "label_id": label_id ?? ""
            ]
        }
    }
}

// MARK: - HomeModel
struct Home: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: DataClass
}

struct CategoryList: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: CategoryClass
}

struct CategoryClass: Codable {
    let products: [Product]
    let category_banner: [CategoryBanner]
}

// MARK: - DataClass
struct DataClass: Codable {
    let category: [DataCategory]
    let advertTop, advertMiddle: [Advert]
    let imageLabels: [ImageLabel]
    let labels: [Label]
    let shop: Shop

    enum CodingKeys: String, CodingKey {
        case category = "category"
        case advertTop = "advert_top"
        case advertMiddle = "advert_middle"
        case imageLabels = "image_labels"
        case labels = "labels"
        case shop = "shop"
    }
}

// MARK: - Shop
struct Shop: Codable {
    let id, name, code, regionID: String
    let cityID, detail, telephone, openTime: String
    let longitude, latitude, status, adminID: String
    let created, modified, image: String
    let distance: Int
    let regionName, cityName: String

    enum CodingKeys: String, CodingKey {
        case id, name, code
        case regionID = "region_id"
        case cityID = "city_id"
        case detail, telephone
        case openTime = "open_time"
        case longitude, latitude, status
        case adminID = "admin_id"
        case created, modified, image, distance
        case regionName = "region_name"
        case cityName = "city_name"
    }
}

// MARK: - Advert
struct Advert: Codable {
    let id, name, location, type: String
    let content, productIDS, sort, showFlag: String
    let created, modified: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case id, name, location, type, content
        case productIDS = "product_ids"
        case sort = "sort"
        case showFlag = "show_flag"
        case created, modified, image
    }
}

// MARK: - DataCategory
struct DataCategory: Codable {
    let id, name, level, parentID: String
    let pointRate, sort, showFlag, created: String
    let modified, image: String
    let category: [CategoryCategory]

    enum CodingKeys: String, CodingKey {
        case id, name, level
        case parentID = "parent_id"
        case pointRate = "point_rate"
        case sort = "sort"
        case showFlag = "show_flag"
        case created, modified, image, category
    }
}

// MARK: - CategoryCategory
struct CategoryCategory: Codable {
    let id, name, level, parentID: String
    let pointRate, sort, showFlag, created: String
    let modified, image: String

    enum CodingKeys: String, CodingKey {
        case id, name, level
        case parentID = "parent_id"
        case pointRate = "point_rate"
        case sort = "sort"
        case showFlag = "show_flag"
        case created, modified, image
    }
}

// MARK: - ImageLabel
struct ImageLabel: Codable {
    let id, name, code, sort: String
    let showFlag, firstKnow, created, modified: String
    let image, type: String

    enum CodingKeys: String, CodingKey {
        case id, name, code, sort
        case showFlag = "show_flag"
        case firstKnow = "first_know"
        case created, modified, image, type
    }

    func getImageUri() -> String {
        if image.isEmpty {
            return "https://app.necesstore.com/upload/advert/o_10530652.jpg"
        }
        return image
    }
}

// MARK: - Label
struct Label: Codable {
    let id: String
    let name, code: String
    let sort: String
    let showFlag, created, modified, image: String
    let product: [Product]

    enum CodingKeys: String, CodingKey {
        case name, code, id, sort
        case showFlag = "show_flag"
        case created, modified, image, product
    }
}

// MARK: - Product
struct Product: Codable {
    let id, name, price, oldPrice: String
    let image: String
    let saleCnt, created, title: String

    enum CodingKeys: String, CodingKey {
        case id, name, price, title
        case oldPrice = "old_price"
        case image
        case saleCnt = "sale_cnt"
        case created
    }
}

struct CategoryBanner: Codable {
    let id, categoryID, type, content: String
    let productIDS, showFlag, created, modified: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case type, content
        case productIDS = "product_ids"
        case showFlag = "show_flag"
        case created, modified, image
    }
}


// MARK: - Search
struct Search: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: [String]
}

