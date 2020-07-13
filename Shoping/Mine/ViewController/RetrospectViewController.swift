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
    var footerView: UIView!
    var hisTableView: UITableView!
    
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
        let g = UIView(frame: CGRect(x: 20, y: 0, width: 40, height: 40))
        let vi = UIImageView(frame: CGRect(x: 20, y: 10, width: 20, height: 20))
        vi.image = UIImage(named: "search")
        g.addSubview(vi)
        search.leftView = g
//        titleView.addSubview(seachText)

//        view.addSubview(titleView)
        tableView.register(UINib(nibName: "RetrospectGoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "RetrospectGoodsTableViewCell")
        tableView.register(UINib(nibName: "RetrospecTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "RetrospecTitleTableViewCell")
        tableView.register(UINib(nibName: "RetrospecGoodsTableViewCell", bundle: nil), forCellReuseIdentifier: "RetrospecGoodsTableViewCell")
        tableView.register(UINib(nibName: "ChanpinZhuisuTableViewCell", bundle: nil), forCellReuseIdentifier: "ChanpinZhuisuTableViewCell")
        tableView.register(UINib(nibName: "LogisticsTableViewCell", bundle: nil), forCellReuseIdentifier: "LogisticsTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.tableviewBackgroundColor
        tableView.separatorStyle = .none

        footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        hisTableView = UITableView(frame: CGRect(x: 16, y: 0, width: view.frame.width - 32, height: 0), style: .plain)
        hisTableView.delegate = self
        hisTableView.dataSource = self
        hisTableView.rowHeight = UITableView.automaticDimension
        hisTableView.backgroundColor = UIColor.tableviewBackgroundColor
        hisTableView.separatorStyle = .none
        hisTableView.tag = 603
        hisTableView.isScrollEnabled = false
        hisTableView.register(UINib(nibName: "LogisticsTableViewCell", bundle: nil), forCellReuseIdentifier: "LogisticsTableViewCell")
        footerView.addSubview(hisTableView)
        tableView.tableFooterView = footerView
        loadData()
    }

    func loadData() {
        API.retrospectData(product_code: search.text ?? "").request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
                self.hisTableView.reloadData()
                let h = (data.data.orderShipping.list.count * 90) + 200

                self.hisTableView.frame = CGRect(x: 16, y: 0, width: self.view.frame.width - 32, height: CGFloat(h))

                self.footerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: CGFloat(h))
                self.tableView.tableFooterView = self.footerView
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

    @objc func copyNum() {
        let pastboard = UIPasteboard.general
        pastboard.string = self.data?.data.orderShipping.number
        CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "复制成功", duration: 1)
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
        if tableView.tag == 603 {
            return data?.data.orderShipping.list.count ?? 0
        }
        return data == nil ? 0 : 3
       }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 603 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogisticsTableViewCell") as! LogisticsTableViewCell
                        cell.selectionStyle = .none
            let item = data?.data.orderShipping.list[indexPath.row]
                        cell.name.text = item?.status
                        cell.date.text = item?.time
                        if indexPath.row == 0 {
                            cell.top.isHidden = true
                            cell.dian.image = UIImage(named: "实时位置")
                        } else {
                            cell.top.isHidden = false
                            cell.dian.image = UIImage(named: "已到达")
                        }
            if indexPath.row == (data?.data.orderShipping.list.count ?? 0) - 1 {
                            cell.bottom.isHidden = true
                        } else {
                            cell.bottom.isHidden = false
                        }
                        return cell
        }
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RetrospectGoodsTableViewCell") as! RetrospectGoodsTableViewCell
            cell.selectionStyle = .none
            cell.img.af_setImage(withURL: URL(string: (data?.data.product.image)!)!)
            cell.name.text = data?.data.product.name
            cell.info.text = "￥\(data?.data.product.price ?? "0")"
            cell.category.text = "\(data?.data.product.categoryName ?? "")>\(data?.data.product.pCategoryName ?? "")"
            cell.date.text = data?.data.product.created
            return cell
        } else if indexPath.row == 1 {
           let cell = tableView.dequeueReusableCell(withIdentifier: "RetrospecGoodsTableViewCell") as! RetrospecGoodsTableViewCell
        let item = data?.data.orderProduct
        cell.sccj.text = item?.factory
        cell.scrq.text = item?.productionDate
        cell.scfzr.text = item?.producer
        cell.gmdd.text = item?.store_name
        cell.gmsj.text = item?.created
        cell.mgjsr.text = item?.staff_name
           cell.selectionStyle = .none
           return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChanpinZhuisuTableViewCell") as! ChanpinZhuisuTableViewCell
            cell.name.text = data?.data.orderShipping.expName
            cell.num.text = data?.data.orderShipping.number
            cell.btn.addTarget(self, action: #selector(copyNum), for: .touchUpInside)
            cell.selectionStyle = .none
               return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogisticsTableViewCell") as! LogisticsTableViewCell
            cell.selectionStyle = .none
//            let item = data?.data.list[indexPath.row]
//            cell.name.text = item?.status
//            cell.date.text = item?.time
//            if indexPath.row == 0 {
//                cell.top.isHidden = true
//                cell.dian.image = UIImage(named: "实时位置")
//            } else {
//                cell.top.isHidden = false
//                cell.dian.image = UIImage(named: "已到达")
//            }
//            if indexPath.row == (self.data?.data.list.count ?? 0) - 1 {
//                cell.bottom.isHidden = true
//            } else {
//                cell.bottom.isHidden = false
//            }
            return cell
        }
   }
}
