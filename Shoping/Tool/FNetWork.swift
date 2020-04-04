//
//  FNetWork.swift
//  BoBoShake
//
//  Created by kirito on 2017/12/15.
//  Copyright © 2019年 kirito. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}
//正式接口
//let urlheadr = "https://api.zgkjb.com/"

//测试接口
let urlheadr = "https://app.necesstore.com"
let imgUri = "https://app.necesstore.com/front/image_up"

class FNetWork: NSObject {
    //MD5加密
   class func md5String(str:String) -> String{
        let cStr = str.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
//        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }

    //网络请求，post-get 通用
    class func requestData(_ type : MethodType, action:String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Dictionary<String,Any>, _ error: Int) -> ()) {
        
        var dic = parameters
//        let isLogin = UserDefaults.standard.bool(forKey: "myUserDataIsLog")
//        if isLogin {
//            dic!["session_token"] = UserDefaults.standard.object(forKey: "myUserDatasession_token")
//        }
    
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        // 2.发送网络请求
        let manager = Alamofire.SessionManager.default
        let headers = ["User-Agent":"iPhone"]
        manager.session.configuration.timeoutIntervalForRequest = 30
        manager.request(urlheadr+action, method: method, parameters: dic, encoding: URLEncoding.default, headers: headers).responseData { (response) in
        
        
        }
    }

    class func requestUpload(url: String, data: [Data], parm: String, success: @escaping(_ response: [String: AnyObject])->(), fail:@escaping(_ error: Error) -> ()){
        let headers = ["content-type":"multipart/form-data","obj_name":parm]
        CLProgressHUD.show(in: UIApplication.shared.keyWindow?.rootViewController?.view, delegate: self, tag: 90000, title: "正在上传...")
           Alamofire.upload(multipartFormData: { (multipartFormData) in


            for (key, value) in headers {
                //参数的上传
                multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
            }
               //多张图片上传
               for i in 0..<data.count{
                   //设置图片的名字
                   let formatter = DateFormatter()
                   formatter.dateFormat = "yyyyMMddHHmmss"
                   let string = formatter.string(from: Date())
                   let filename = "\(string).png"
                   multipartFormData.append(data[i], withName: "file", fileName: filename, mimeType: "image/png")
               }
           }, to: imgUri, headers: headers, encodingCompletion:{ encodingResult in
               switch encodingResult{
               case .success(request: let upload,_,_):
                CLProgressHUD.dismiss(byTag: 90000, delegate: self, in: UIApplication.shared.keyWindow?.rootViewController?.view)
                   upload.responseJSON(completionHandler: { (response) in
                       if let value = response.result.value as? [String : AnyObject]{
                           success(value)
                       }
                   })
               case .failure(let error):
                CLProgressHUD.dismiss(byTag: 90000, delegate: self, in: UIApplication.shared.keyWindow?.rootViewController?.view)
                   fail(error)
               }
           })
        }
}

