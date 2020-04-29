//
//  BarCodeViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/27.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class BarCodeViewController: UIViewController {

    @IBOutlet weak var er: UIImageView!
    @IBOutlet weak var tiao: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        loadData()
    }

    @IBAction func reshAction(_ sender: Any) {
        loadData()
    }
    func loadData() {
        API.getPaymentCode().request { (result) in
            switch result {
            case .success(let data):
                print(data)
                let erimg = self.generateQRCodeImage(data.data, size: CGSize(width: 200, height: 200))
                self.er.image = erimg
                self.tiao.image = self.generateBarCode128(content: data.data, size: CGSize(width: 333, height: 90.5))
            case .failure(let er):
                print(er)
            }
        }
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
