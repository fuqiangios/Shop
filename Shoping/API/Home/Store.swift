//
//  Store.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/22.
//  Copyright © 2020 付强. All rights reserved.
//

import Foundation

struct StoreList: Codable {
    let data: [StoreCity]
}

struct StoreCity: Codable {
    let cityName: String
    let cityId: String
    let cityStore: [Store]
}
