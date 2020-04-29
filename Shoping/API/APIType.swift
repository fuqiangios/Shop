//
//  APIType.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/31.
//  Copyright © 2020 付强. All rights reserved.
//

import Foundation
import Alamofire

enum APIMethod {
    case get
    case post
    case put
    case delete

    var httpMethod: HTTPMethod {
        switch self {
        case .get:
            return HTTPMethod.get
        case .post:
            return HTTPMethod.post
        case .put:
            return HTTPMethod.put
        case .delete:
            return HTTPMethod.delete
        }
    }
}
//yum install  php56w-cli php56w-common php56w-devel php56w-gd php56w-pdo php56w-mysql php56w-mbstring php56w-bcmath
protocol APIType {
    associatedtype Node: Decodable
    var path: String { get }
    func method() -> APIMethod
    func parameters() -> [String: Any]?
}

protocol Post: APIType {
}
extension Post {
    func method() -> APIMethod {
        return .post
    }
}

protocol Put: APIType {
}
extension Put {
    func method() -> APIMethod {
        return .put
    }
}

protocol Get: APIType {
}

extension Get {
    func method() -> APIMethod {
        return .get
    }
}

extension APIType {
    func method() -> APIMethod {
        return .get
    }

    func parameters() -> [String: Any]? {
        return nil
    }

    func request(completionHandle: @escaping (_ result : Result<Node>) -> ()) {
               // 2.发送网络请求
        let manager = Alamofire.SessionManager.default
        let headers = ["User-Agent":"iPhone"]
        let url = urlheadr + "/" + path
        let encoding: ParameterEncoding
        let method = self.method()
        if method == .get {
            encoding = URLEncoding.default
        } else {
            encoding = JSONEncoding(options: [])
        }

        var parames = parameters()
        if UserSetting.default.activeUserToken != nil {
            if parames?["user_token"] == nil {
                parames?["user_token"] = UserSetting.default.activeUserToken
            }
        }
        //01ff5de49ffac39fe540ca8cc0708536c8453bcf
        manager.session.configuration.timeoutIntervalForRequest = 30
        manager.request(url, method: method.httpMethod, parameters: parames, encoding: URLEncoding.default, headers: headers).responseData { (response) in
            do {
                switch response.result {
                case .success(let data):
                    let value = try JSONDecoder().decode(Node.self, from: data)
                    completionHandle(.success(value))
                case .failure(let error):
//                    CLProgressHUD.showError(in: UIApplication.shared.keyWindow?.rootViewController?.view, delegate: self, title: error.localizedDescription, duration: 1)
                    completionHandle(.failure(error))
                }
            } catch let decodingError as DecodingError {
                if let json = try? JSONSerialization.jsonObject(with: response.data!, options: [.allowFragments]) {
                    #if DEBUG
                    print(json)
                    #endif
                      let dic = json as! Dictionary<String,Any>
                    if dic["message"] != nil {

//                    CLProgressHUD.showError(in: UIApplication.shared.keyWindow?.rootViewController?.view, delegate: self, title: dic["message"]as!String, duration: 1)
                    }else{
//                       CLProgressHUD.showError(in: UIApplication.shared.keyWindow?.rootViewController?.view, delegate: self, title: "操作失败", duration: 1)
                    }
                }


                completionHandle(.failure(decodingError))
            } catch {
//                CLProgressHUD.showError(in: UIApplication.shared.keyWindow?.rootViewController?.view, delegate: self, title: error.localizedDescription, duration: 1)
                completionHandle(.failure(error))
            }

        }


    }
}

enum APIError {
    case network
    case invalid
    case exception(code: String, message: String)
}

enum API {
}
