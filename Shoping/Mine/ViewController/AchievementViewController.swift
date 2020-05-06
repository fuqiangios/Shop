//
//  AchievementViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/18.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class AchievementViewController: UIViewController {
    @IBOutlet weak var newFriedn: UILabel!
    @IBOutlet weak var cityLabel: UITextField!

    @IBOutlet weak var storeLabel: UITextField!
    @IBOutlet weak var regionLabel: UITextField!
    @IBOutlet weak var myFriend: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var shangyueyeji: UILabel!

    @IBOutlet weak var detail: UIView!
    @IBOutlet weak var bennnianyeji: UILabel!
    @IBOutlet weak var shangjiyeji: UILabel!
    @IBOutlet weak var benyueyeji: UILabel!
    @IBOutlet weak var zuoriyeji: UILabel!
    @IBOutlet weak var friendNum: UILabel!
    var data: Achievement? = nil
    var cityData: [City] = []
    var storeData: [AchievementStore] = []
    var info: AchievementInfo? = nil
    var regionId = ""
    var cityId = ""
    var storeId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        title = "业绩查询"
        scrollView.contentSize = CGSize(width: 0, height: 854)
        checkBtn.layer.cornerRadius = 25
        checkBtn.layer.masksToBounds = true
        detail.isHidden = true
        loadData()
    }
    func loadData() {
        API.achievementData().request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.myFriend.text = data.data.number
                self.newFriedn.text = data.data.total
            case .failure(let er):
                print(er)
            }
        }
    }

    @IBAction func checkAction(_ sender: Any) {
        if storeId == "" {
            CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "请选择门店信息", duration: 1)
        }
        API.achievementInfo(store_id: storeId).request { (result) in
            switch result {
            case .success(let data):
                self.detail.isHidden = false
                self.info = data
                self.name.text = self.storeLabel.text
                self.friendNum.text = data.data.number
                self.zuoriyeji.text = "￥\(data.data.yesTotal)"
                self.benyueyeji.text = "￥\(data.data.nowMonthTotal)"
                self.shangyueyeji.text = "￥\(data.data.lastMonthTotal)"
                self.bennnianyeji.text = "￥\(data.data.yearTotal)"
            case .failure(let er):
                print(er)
            }
        }
    }

    @IBAction func regionAction(_ sender: Any) {
        if data?.data.tree.isEmpty ?? true {return}
        let dat = data?.data.tree ?? []
        let alertController = UIAlertController(title: "请选择大区", message: "", preferredStyle: UIAlertController.Style.actionSheet)

        for item in dat {
            alertController.addAction(UIAlertAction(title: "\(item.region.name)", style: UIAlertAction.Style.default, handler:{ (l) in
                self.regionId = item.region.id
                self.cityData = item.city
                self.regionLabel.text = item.region.name
                self.cityId = ""
                self.storeData = []
                self.cityLabel.text = ""
                self.storeId = ""
                self.storeLabel.text = ""
                }))
        }
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func cityAction(_ sender: Any) {
        if regionId.isEmpty {return}
        let alertController = UIAlertController(title: "请选择城市", message: "", preferredStyle: UIAlertController.Style.actionSheet)

        for item in cityData {
            alertController.addAction(UIAlertAction(title: "\(item.name)", style: UIAlertAction.Style.default, handler:{ (l) in
                self.cityId = item.id
                self.storeData = item.store
                self.cityLabel.text = item.name
                self.storeId = ""
                self.storeLabel.text = ""
                }))
        }
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func storeAction(_ sender: Any) {
        if cityId.isEmpty {return}
        let alertController = UIAlertController(title: "请选择店铺", message: "", preferredStyle: UIAlertController.Style.actionSheet)

        for item in storeData {
            alertController.addAction(UIAlertAction(title: "\(item.name)", style: UIAlertAction.Style.default, handler:{ (l) in
                self.storeId = item.id
                self.storeLabel.text = item.name
                }))
        }
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(alertController, animated: true, completion: nil)
    }
}
