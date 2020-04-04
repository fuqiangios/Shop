//
//  Type.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/20.
//  Copyright © 2020 付强. All rights reserved.
//

import Foundation

extension API {
    struct typeList: Get {
        typealias Node = TypeList
        var path: String = "front/category"

        init() {
        }

        func parameters() -> [String: Any]? {
            return [:]
        }
    }
}

// MARK: - AddressList
struct TypeList: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: [TypeDatum]
}

// MARK: - Datum
struct TypeDatum: Codable {
    let id, name, level, parentID: String
    let pointRate, sort, showFlag, created: String
    let modified, image: String
    let category: [Category]

    enum CodingKeys: String, CodingKey {
        case id, name, level
        case parentID = "parent_id"
        case pointRate = "point_rate"
        case sort
        case showFlag = "show_flag"
        case created, modified, image, category
    }
}

// MARK: - Category
struct Category: Codable {
    let id, name, level, parentID: String
    let pointRate, sort, showFlag, created: String
    let modified, image: String

    enum CodingKeys: String, CodingKey {
        case id, name, level
        case parentID = "parent_id"
        case pointRate = "point_rate"
        case sort
        case showFlag = "show_flag"
        case created, modified, image
    }

    func getImg() -> String {
        if image.isEmpty {
            return "https://app.necesstore.com/upload/advert/o_10530652.jpg"
        }
        return image
    }
}
