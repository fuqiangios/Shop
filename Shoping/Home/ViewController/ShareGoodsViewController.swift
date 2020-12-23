//
//  ShareGoodsViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/12/15.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class ShareGoodsViewController: UIViewController {
    @IBOutlet weak var topImage: UIImageView!

    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image1: UIImageView!

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var info: UILabel!

    @IBOutlet weak var qaCodeImg: UIImageView!
    @IBOutlet weak var salesNum: UILabel!
    @IBOutlet weak var oldPrice: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var goodsName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userIcon: UIImageView!
    var toGoodsDetail: ((Int) -> Void)!
    var data: InnviteGoods? = nil
    var qrcodeUri: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
        userIcon.layer.cornerRadius = 45/2
        userIcon.layer.masksToBounds = true

        topImage.af_setImage(withURL: URL(string: (data?.data!.image)!)!)
        if data?.data?.images.count ?? 0 >= 1 {
            image1.af_setImage(withURL: URL(string: (data?.data?.images[0].image)!)!)
        }
        if data?.data?.images.count ?? 0 >= 2 {
            image2.af_setImage(withURL: URL(string: (data?.data?.images[1].image)!)!)
        }
        if data?.data?.images.count ?? 0 >= 3 {
            image3.af_setImage(withURL: URL(string: (data?.data?.images[2].image)!)!)
        }
        if data?.data?.images.count ?? 0 >= 4 {
            image4.af_setImage(withURL: URL(string: (data?.data?.images[3].image)!)!)
        }
        if let ig = data?.data!.userImage {
            userIcon.af_setImage(withURL: URL(string: (ig))!)
        }
        userName.text = data?.data?.userName
        goodsName.text = data?.data?.name
        info.text = data?.data?.recommendContent
        setPri(str: "￥\(data?.data?.price ?? "0.00")")
        salesNum.text = "销量: \(data?.data?.saleCnt ?? "0")"
        setOldPri(str: "￥\(data?.data?.oldPrice ?? "0.00")")
        qaCodeImg.image = generateQRCodeImage(qrcodeUri!, size: CGSize(width: 200, height: 200))
    }

    func setPri(str: String) {
        let fontAttr = NSMutableAttributedString(string: str)
        fontAttr.addAttribute(.font, value: UIFont.systemFont(ofSize: 10), range: NSRange(location: 0, length: 1))
        fontAttr.addAttribute(.baselineOffset, value: 5, range: NSRange(location: 0, length: 1))
        price.attributedText = fontAttr
    }

    func setOldPri(str: String) {
        let fontAttr = NSMutableAttributedString(string: str)
        fontAttr.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: str.count))
        oldPrice.attributedText = fontAttr
    }


    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func saveImg(_ sender: Any) {

        getImageFromView(view: bgView)
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

    

    func getImageFromView(view:UIView) ->UIImage{

            UIGraphicsBeginImageContext(view.bounds.size)

            view.layer.render(in: UIGraphicsGetCurrentContext()!)

            let image = UIGraphicsGetImageFromCurrentImageContext()

            UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)

            return image!
   }

    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
            if error != nil{
                print("保存失败")
                CLProgressHUD.showError(in: self.view, delegate: self, title: "保存失败", duration: 1)
                self.dismiss(animated: false, completion: nil)
            }else{
                print("保存成功")
                CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "保存成功", duration: 1)
                self.dismiss(animated: false, completion: nil)
            }
    }
}
