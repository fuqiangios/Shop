import Foundation

extension API {
    struct clearMessage: Post {
        typealias Node = CartNumChange
        var path: String = "customer/message_del"

        init() {
        }

        func parameters() -> [String: Any]? {
            return [
                "": "",
             ]
        }
    }

    struct getPaymentCode: Post {
        typealias Node = PaymentCode
        var path: String = "customer/payment_code"

        init() {
        }

        func parameters() -> [String: Any]? {
            return [
                "": "",
             ]
        }
    }

    struct getShare: Post {
        typealias Node = Share
        var path: String = "customer/invite_recommend"

        init() {
        }

        func parameters() -> [String: Any]? {
            return [
                "": "",
             ]
        }
    }

    struct getExpiainn: Post {
        typealias Node = Expiain
        var path: String = "front/disclaimer"
        let code: String
        init(code: String) {
            self.code = code
        }

        func parameters() -> [String: Any]? {
            return [
                "code": code,
             ]
        }
    }

    struct getContact: Post {
        typealias Node = Contact
        var path: String = "customer/contact"

        init() {
            
        }

        func parameters() -> [String: Any]? {
            return [
                "":""
             ]
        }
    }

    struct messageList: Post {
        typealias Node = Message
        var path: String = "customer/message"

        let type: String
        let page: String
        init(type: String, page: String) {
            self.type = type
            self.page = page
        }

        func parameters() -> [String: Any]? {
            return [
                "type": type,
                "page": page
             ]
        }
    }
}

// MARK: - Message
struct Message: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: [MessageDatum]
}

// MARK: - Datum
struct MessageDatum: Codable {
    let id, type, content, customerID: String
    let operatorType, operatorID, created, modified: String
    let typeName: String

    enum CodingKeys: String, CodingKey {
        case id, type, content
        case customerID = "customer_id"
        case operatorType = "operator_type"
        case operatorID = "operator_id"
        case created, modified
        case typeName = "type_name"
    }
}


// MARK: - PaymentCode
struct PaymentCode: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: String
}


// MARK: - Share
struct Share: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: ShareDataClass
}

// MARK: - DataClass
struct ShareDataClass: Codable {
    let signUpGift, inviteCode: String

    enum CodingKeys: String, CodingKey {
        case signUpGift = "sign_up_gift"
        case inviteCode = "invite_code"
    }
}

// MARK: - Share
struct Expiain: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: ExpiainData
}
struct ExpiainData: Codable {
    let content: String
}

struct Contact: Codable {
    let result: Bool
    let message: String
    let status: Int
    let data: ContactData
}
struct ContactData: Codable {
    let contact: ContactInfo
}
struct ContactInfo: Codable {
    let telephone: String
    let wx: String
}

