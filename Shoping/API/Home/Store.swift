//
//  Store.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/22.
//  Copyright © 2020 付强. All rights reserved.
//

import Foundation

extension API {
    struct storeData: Post {
        typealias Node = StoreList
        var path: String = "front/city_store_list"
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

    struct getVipData: Get {
        typealias Node = VIPData
        var path: String = "vip/index"

        init() {
        }
    }

    struct submitProduct: Post {
        typealias Node = ProductData
        var path: String = "vip/project_enter"
        let id: String
        init(id: String) {
            self.id = id
        }
        func parameters() -> [String: Any]? {
            return [
                "id": id
            ]
        }
    }
}

// MARK: - StoreList
struct StoreList: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: [StoreDatum]
}

// MARK: - Datum
struct StoreDatum: Codable {
    let id, name, level, zoneCode: String
    let parentID, created, modified: String
    let shops: [ShopInfo]

    enum CodingKeys: String, CodingKey {
        case id, name, level
        case zoneCode = "zone_code"
        case parentID = "parent_id"
        case created, modified, shops
    }
}

// MARK: - Shop
struct ShopInfo: Codable {
    let id, name, code, regionID: String
    let cityID, detail, telephone, openTime: String
    let longitude, latitude, status, adminID: String
    let created, modified, image: String
    let distance: String

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

// MARK: - VIPData
struct VIPData: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: VIPDataDataClass
}

// MARK: - DataClass
struct VIPDataDataClass: Codable {
    let member, shareholder: [Member]
    let crowdfunding: [Crowdfunding]
    let project: [Project]
}

// MARK: - Crowdfunding
struct Crowdfunding: Codable {
    let id, name, value, title: String
    let content, sort, created, modified: String
}

// MARK: - Member
struct Member: Codable {
    let name, memo: String
}

// MARK: - Project
struct Project: Codable {
    let id, name, content, image: String
    let initiatorID, initiatorName, initiatorImage, target: String
    let support, raise, reach, showFlag, intro: String
    let created, modified: String

    enum CodingKeys: String, CodingKey {
        case id, name, content, image
        case initiatorID = "initiator_id"
        case initiatorName = "initiator_name"
        case initiatorImage = "initiator_image"
        case target, support, raise, reach
        case showFlag = "show_flag"
        case created, modified, intro
    }
}

// MARK: - VIPData
struct VIPProductData: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: Project
}

// MARK: - VIPData
struct ProductData: Codable {
    let result: Bool
    let message: String
    let status: Int
}

// MARK: - DataClass
struct ProductDataClass: Codable {
    let customerID, projectID: String

    enum CodingKeys: String, CodingKey {
        case customerID = "customer_id"
        case projectID = "project_id"
    }
}
