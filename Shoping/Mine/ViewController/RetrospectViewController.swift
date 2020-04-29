//
//  RetrospectViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/18.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class RetrospectViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var search: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var data: Retrospect? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        title = "产品追溯"
//        let titleView = UIView(frame: CGRect(x: 16, y: 10, width: view.frame.width - 70, height: 40))
        search.layer.cornerRadius = 20
//        titleView.backgroundColor = UIColor.lightColor

//        let seachText = UITextField(frame: CGRect(x: 10, y: 0, width: titleView.frame.size.width, height: 40))
        search.placeholder = "输入产品编号"
        search.delegate = self
        search.font = UIFont.PingFangSCLightFont16
        search.backgroundColor = UIColor.lightColor
//        textField.leftViewMode = UITextFieldViewModeAlways;
        search.leftViewMode = .always
        let vi = UIImageView(frame: CGRect(x: 20, y: 0, width: 20, height: 40))
        vi.image = UIImage(named: "search")
        search.leftView = vi

//        titleView.addSubview(seachText)

//        view.addSubview(titleView)
        tableView.register(UINib(nibName: "RetrospectGoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "RetrospectGoodsTableViewCell")
        tableView.register(UINib(nibName: "RetrospecTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "RetrospecTitleTableViewCell")
        tableView.register(UINib(nibName: "RetrospecStoreTableViewCell", bundle: nil), forCellReuseIdentifier: "RetrospecStoreTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.tableviewBackgroundColor
        tableView.separatorStyle = .none
        loadData()
    }

    func loadData() {
        API.retrospectData(product_code: search.text ?? "").request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty ?? true {return false}
        textField.resignFirstResponder()
        loadData()
        return true
    }

    @IBAction func sacnAction(_ sender: Any) {
        recoCropRect()
    }
    // MARK: - ---框内区域识别
    func  recoCropRect() {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.On
        style.photoframeLineW = 6
        style.photoframeAngleW = 24
        style.photoframeAngleH = 24
        style.isNeedShowRetangle = true

        style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid

        //矩形框离左边缘及右边缘的距离
        style.xScanRetangleOffset = 80

        //使用的支付宝里面网格图片
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_part_net")

        let vc = LBXScanViewController()
        vc.scanStyle = style
        vc.scanResultDelegate = self
        vc.isOpenInterestRect = true
        //TODO:待设置框内识别
        self.navigationController?.pushViewController(vc, animated: true)

    }
}
extension RetrospectViewController: UITableViewDataSource, UITableViewDelegate, LBXScanViewControllerDelegate {
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        if let result = scanResult.strScanned {
            search.text = result
            loadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data == nil ? 0 : 2 + (data?.data.storeProduct.count ?? 0)
       }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RetrospectGoodsTableViewCell") as! RetrospectGoodsTableViewCell
            cell.selectionStyle = .none
            cell.img.af_setImage(withURL: URL(string: (data?.data.product.image)!)!)
            cell.name.text = data?.data.product.name
            cell.info.text = "￥\(data?.data.product.price ?? "0")"
            cell.category.text = "\(data?.data.product.categoryName ?? "")>\(data?.data.product.pCategoryName ?? "")"
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RetrospecTitleTableViewCell") as! RetrospecTitleTableViewCell
            cell.selectionStyle = .none
            return cell
        }
           let cell = tableView.dequeueReusableCell(withIdentifier: "RetrospecStoreTableViewCell") as! RetrospecStoreTableViewCell
        let item = data?.data.storeProduct[indexPath.row - 2]
        cell.name.text = "\(item?.name ?? "")店 有库存"
        cell.inName.text = "\(item?.name ?? "")店"
        cell.inNum.text = "\(item?.stock ?? "0")"
        cell.inPName.text = "\(item?.productName ?? "")"
        cell.date.text = "上次更新时间: \(item?.updateTime ?? "")"
           cell.selectionStyle = .none
           return cell
       }
}
