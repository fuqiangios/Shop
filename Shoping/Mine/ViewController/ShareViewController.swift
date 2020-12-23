//
//  ShareViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/18.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController, UMSocialShareMenuViewDelegate {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var sh: UIButton!
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var info: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "邀请好友"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        sh.layer.cornerRadius = 5
        sh.layer.masksToBounds = true
        UMSocialUIManager.setShareMenuViewDelegate(self)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
        loadData()
    }

    func loadData() {
        API.getShare().request { (result) in
            switch result {
            case .success(let data):
//                self.info.text = data.data.signUpGift
                self.code.text = data.data.inviteCode
                let erimg = self.generateQRCodeImage("https://app.necesstore.com/html/invite.html?invite_code=\(self.code.text ?? "")", size: CGSize(width: 200, height: 200))
                self.img.image = erimg
            case .failure(let er):
                print(er)
            }
        }
    }

    @IBAction func shareAction(_ sender: Any) {
//        let req = SendMessageToWXReq()
//        req.text = "分享"
//        req.bText = true
//        req.scene = Int32(WXSceneSession.rawValue)
//        WXApi.send(req) { (item) in
//            print(item)
//        }

//        UMSocialManager.default()?.getUserInfo(with: .wechatSession, currentViewController: nil, completion: { (result, er) in
//            print(result)
//            print(er)
//        })

//        UMSocialUIManager.showShareMenuViewInWindow { (type, userInfo) in
//
//        }
//        let m = UMSocialMessageObject()
//        let s = UMShareWebpageObject.shareObject(withTitle: "我家有品", descr: "欢迎使用", thumImage: nil)
//        s?.webpageUrl = "www.baidu.com"
//        m.shareObject = s
//        UMSocialManager.default()?.share(to: .wechatSession, messageObject: m, currentViewController: self, completion: { (le, er) in
//            print(er)
//            print(le)
//        })
        //调用setPreDefinePlatforms的示例
        UMSocialUIManager.setPreDefinePlatforms([NSNumber(integerLiteral:UMSocialPlatformType.wechatSession.rawValue),NSNumber(integerLiteral:UMSocialPlatformType.wechatTimeLine.rawValue)])
        UMSocialUIManager.removeAllCustomPlatformWithoutFilted()
        UMSocialShareUIConfig.shareInstance()?.sharePageGroupViewConfig.sharePageGroupViewPostionType = .bottom
        UMSocialShareUIConfig.shareInstance()?.sharePageScrollViewConfig.shareScrollViewPageItemStyleType = .iconAndBGRoundAndSuperRadius
        UMSocialUIManager.showShareMenuViewInWindow { (type, info) in
            let t = type as! UMSocialPlatformType
            let m = UMSocialMessageObject()
                    let s = UMShareWebpageObject.shareObject(withTitle: "时时分享有收益，天天购物有大奖，月月消费送医保，晚年免费来养老~", descr: "注册我家用品APP，免费红包送到手软~", thumImage: UIImage(named: "27211590459319_.pic_hd"))
            s?.webpageUrl = "\(urlheadr)/html/invite.html?invite_code=\(self.code.text ?? "")"
                    m.shareObject = s
                    UMSocialManager.default()?.share(to: t, messageObject: m, currentViewController: self, completion: { (le, er) in
                        print(er)
                        print(le)
                    })
        }
    }

//    func umSocialParentView(_ defaultSuperView: UIView!) -> UIView! {
//        return defaultSuperView
//    }
    func umSocialShareMenuViewDidAppear() {
        print(11)
    }
    func umSocialShareMenuViewDidDisappear() {
        print(222)
    }
    
    @IBAction func copyAction(_ sender: Any) {
        let pastboard = UIPasteboard.general
        pastboard.string = code.text ?? ""
        CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "复制成功", duration: 1)
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func generateQRCodeImage(_ content: String, size: CGSize) -> UIImage?
        {
        // 创建滤镜
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {return nil}
        // 还原滤镜的默认属性
        filter.setDefaults()
        // 设置需要生成的二维码数据
        let contentData = content.data(using: String.Encoding.utf8)
        filter.setValue(contentData, forKey: "inputMessage")

        // 从滤镜中取出生成的图片
        guard let ciImage = filter.outputImage else {return nil}

        let context = CIContext(options: nil)
        let bitmapImage = context.createCGImage(ciImage, from: ciImage.extent)

        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)

        //draw image
        let scale = min(size.width / ciImage.extent.width, size.height / ciImage.extent.height)
        bitmapContext!.interpolationQuality = CGInterpolationQuality.none
        bitmapContext?.scaleBy(x: scale, y: scale)
        bitmapContext?.draw(bitmapImage!, in: ciImage.extent)

        //保存bitmap到图片
        guard let scaledImage = bitmapContext?.makeImage() else {return nil}

        return UIImage(cgImage: scaledImage)
        }
    //CICode128BarcodeGenerator
        func generateBarCode128(content:String,size:CGSize) ->UIImage? {
               // 创建滤镜
                guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else {return nil}
                // 还原滤镜的默认属性
                filter.setDefaults()
                // 设置需要生成的二维码数据
                let contentData = content.data(using: String.Encoding.utf8)
                filter.setValue(contentData, forKey: "inputMessage")

                // 从滤镜中取出生成的图片
                guard let ciImage = filter.outputImage else {return nil}

                let context = CIContext(options: nil)
                let bitmapImage = context.createCGImage(ciImage, from: ciImage.extent)

                let colorSpace = CGColorSpaceCreateDeviceGray()
                let bitmapContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)

                //draw image
                let scale = min(size.width / ciImage.extent.width, size.height / ciImage.extent.height)
                bitmapContext!.interpolationQuality = CGInterpolationQuality.none
                bitmapContext?.scaleBy(x: scale, y: scale)
                bitmapContext?.draw(bitmapImage!, in: ciImage.extent)

                //保存bitmap到图片
                guard let scaledImage = bitmapContext?.makeImage() else {return nil}

                return UIImage(cgImage: scaledImage)
            }
}
