//
//  AchievementViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/18.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import MJRefresh

class AchievementViewController: UIViewController {
    @IBOutlet weak var newFriedn: UILabel!
    @IBOutlet weak var cityLabel: UITextField!

    @IBOutlet weak var storeLabel: UITextField!
    @IBOutlet weak var regionLabel: UITextField!
    @IBOutlet weak var myFriend: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var shangyueyeji: UILabel!

    @IBOutlet weak var jName: UILabel!
    @IBOutlet weak var fName: UILabel!
    @IBOutlet weak var detail: UIView!
    @IBOutlet weak var bennnianyeji: UILabel!
    @IBOutlet weak var shangjiyeji: UILabel!
    @IBOutlet weak var benyueyeji: UILabel!
    @IBOutlet weak var zuoriyeji: UILabel!
    @IBOutlet weak var friendNum: UILabel!

    @IBOutlet weak var tableView: UITableView!
    var data: Achievement? = nil
    var cityData: [City] = []
    var storeData: [AchievementStore] = []
    var info: AchievementInfo? = nil
    var regionId = ""
    var cityId = ""
    var storeId = ""
    var ah: Ahioc? = nil
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        title = "连锁店业绩"
        scrollView.tag = 99
        scrollView.contentSize = CGSize(width: 0, height: 0)
        checkBtn.layer.cornerRadius = 25
        checkBtn.layer.masksToBounds = true
        detail.isHidden = true
        tableView.register(UINib(nibName: "AhioTableViewCell", bundle: nil), forCellReuseIdentifier: "AhioTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.tableviewBackgroundColor
        tableView.separatorStyle = .none
        let hd = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 527))
        hd.addSubview(headerImg)
        hd.addSubview(headerView)
        hd.addSubview(myFriend)
        hd.addSubview(fName)
        hd.addSubview(jName)
        hd.addSubview(newFriedn)
        tableView.tableHeaderView = hd
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page = self.page + 1
            self.checkActionMore()
        })
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.checkAction()
        })
        loadData()
        checkAction()
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

    @IBAction func akk(_ sender: Any) {
        checkAction()
    }

    func checkActionMore() {
    //        if storeId == "" {
    //            CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "请选择门店信息", duration: 1)
    //        }
            API.ahioc(store_id: storeId, region_id: regionId, city_id: cityId, page: "\(page)").request { (result) in
                self.tableView.mj_footer?.endRefreshing()
                            switch result {
                            case .success(let data):
                                var ar = self.ah?.data.store ?? []
                                ar = ar + data.data.store
                                self.ah = Ahioc(result: true, message: "", status: 200, data: AhiocDataClass(number: "", total: "", tree: [], store: ar))
                                self.tableView.reloadData()
                            case .failure(let er):
                                print(er)
                            }
            }
    //        API.achievementInfo(store_id: storeId).request { (result) in
    //            switch result {
    //            case .success(let data):
    //                self.detail.isHidden = false
    //                self.info = data
    //                self.tableView.reloadData()
    //                self.name.text = self.storeLabel.text
    ////                self.friendNum.text = data.data.number
    ////                self.zuoriyeji.text = "￥\(data.data.yesTotal)"
    ////                self.benyueyeji.text = "￥\(data.data.nowMonthTotal)"
    ////                self.shangyueyeji.text = "￥\(data.data.lastMonthTotal)"
    ////                self.bennnianyeji.text = "￥\(data.data.yearTotal)"
    //            case .failure(let er):
    //                print(er)
    //            }
    //        }
        }

    func checkAction() {
//        if storeId == "" {
//            CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "请选择门店信息", duration: 1)
//        }
        API.ahioc(store_id: storeId, region_id: regionId, city_id: cityId, page: "1").request { (result) in
            self.tableView.mj_header?.endRefreshing()
                        switch result {
                        case .success(let data):
                            self.ah = data
                            self.tableView.reloadData()
                        case .failure(let er):
                            print(er)
                        }
        }
//        API.achievementInfo(store_id: storeId).request { (result) in
//            switch result {
//            case .success(let data):
//                self.detail.isHidden = false
//                self.info = data
//                self.tableView.reloadData()
//                self.name.text = self.storeLabel.text
////                self.friendNum.text = data.data.number
////                self.zuoriyeji.text = "￥\(data.data.yesTotal)"
////                self.benyueyeji.text = "￥\(data.data.nowMonthTotal)"
////                self.shangyueyeji.text = "￥\(data.data.lastMonthTotal)"
////                self.bennnianyeji.text = "￥\(data.data.yearTotal)"
//            case .failure(let er):
//                print(er)
//            }
//        }
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

extension AchievementViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ah?.data.store.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AhioTableViewCell") as! AhioTableViewCell
        cell.selectionStyle = .none
        let item = ah?.data.store[indexPath.row]
        cell.name.text = item?.name
        cell.zuoriyeji.text = "￥\(item?.sale.yesTotal ?? "0")"
                        cell.benyueyeji.text = "￥\(item?.sale.nowMonthTotal ?? "0")"
                        cell.shangyueyeji.text = "￥\(item?.sale.lastMonthTotal ?? "0")"
                        cell.bennnianyeji.text = "￥\(item?.sale.yearTotal ?? "0")"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 207
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }


}
