//
//  Address.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/2/18.
//  Copyright © 2020 付强. All rights reserved.
//
import Foundation

extension API {
    struct addressList: Post {
        typealias Node = Address
        var path: String = "/customer/address_list"

        init() {
        }

        func parameters() -> [String: Any]? {
            return [
                "":""
             ]
        }
    }

    struct addressSave: Post {
        typealias Node = AddressSave
        var path: String = "customer/address_edit"

        let info: AddressDatum
        init(info: AddressDatum) {
            self.info = info
        }

        func parameters() -> [String: Any]? {
            let jsonEncoder = JSONEncoder()
            guard let jsonData = try? jsonEncoder.encode(info) else { return ["":""]

            }
            guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
                return ["":""]
            }
            return json as? [String : Any]
        }
    }

    struct addressDelete: Post {
        typealias Node = AddressSave
        var path: String = "customer/address_del"

        let id: String
        init(id: String) {
            self.id = id
        }

        func parameters() -> [String: Any]? {
            return [
                "id":id
            ]
        }
    }
}

struct Address: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: [AddressDatum]
}

struct AddressSave: Codable {
    let result: Bool
    let message: String
    let status: Int
}

// MARK: - Datum
struct AddressDatum: Codable {
    let id,customerID: String?
    let name, telephone: String?
    let address, detail, isDefault: String?
    let modified, created: String?

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case name, telephone, address, detail
        case isDefault = "is_default"
        case created, modified
    }

    func updateAddress(id: String? = nil, name: String? = nil, telephone: String? = nil, address: String? = nil, detail: String? = nil, isDefault: String? = nil, customerID: String? = nil, modified: String? = nil, created: String? = nil) -> AddressDatum {
        
        return AddressDatum(id: (id == nil) ? self.id:id, customerID: (customerID == nil) ? self.customerID:customerID, name: (name == nil) ? self.name:name, telephone: (telephone == nil) ? self.telephone:telephone, address: (address == nil) ? self.address:address, detail: (detail == nil) ? self.detail:detail, isDefault: (isDefault == nil) ? self.isDefault:isDefault,  modified: modified, created: created)
    }
}
