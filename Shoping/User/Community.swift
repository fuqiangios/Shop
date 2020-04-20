//
//  Community.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/19.
//  Copyright © 2020 付强. All rights reserved.
//

import Foundation

// MARK: - CommunityList
struct CommunityList: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: CommunityDataClass
}

// MARK: - DataClass
struct CommunityDataClass: Codable {
    let evaluate: [CommunityEvaluate]
    let advert: [String]
}

// MARK: - Evaluate
struct CommunityEvaluate: Codable {
    let productEvaluateID, productID: String
    let productImage: String
    let productName, zanCnt, customerImage, customerName: String

    enum CodingKeys: String, CodingKey {
        case productEvaluateID = "product_evaluate_id"
        case productID = "product_id"
        case productImage = "product_image"
        case productName = "product_name"
        case zanCnt = "zan_cnt"
        case customerImage = "customer_image"
        case customerName = "customer_name"
    }
}

