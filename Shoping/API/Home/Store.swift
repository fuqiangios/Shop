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
