//
//  MyProductViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/6/30.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class MyProductViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var data: MyProducts? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的项目"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.register(UINib(nibName: "VipProductTableViewCell", bundle: nil), forCellReuseIdentifier: "VipProductTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.tableviewBackgroundColor
        tableView.separatorStyle = .none
        loadData()
    }

    func loadData() {
        API.getMyProducts().request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }
}

extension MyProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return data?.data.myProject.count ?? 0
        }
        return data?.data.otherProject.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

            let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
            header.backgroundColor = .clear
            let ti = UIImageView(frame: CGRect(x: 50, y: 0, width: self.view.frame.width - 100, height: 60))
            if section == 0 {
                ti.image = UIImage(named: "__我参与的项目 _")
                ti.frame = CGRect(x: 90, y: 0, width: self.view.frame.width - 180, height: 60)
            } else {
                ti.image = UIImage(named: "__项目邀约 _")
            }
            ti.contentMode = .scaleAspectFit
            header.addSubview(ti)
            return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VipProductTableViewCell") as! VipProductTableViewCell
        cell.selectionStyle = .none

        if indexPath.section == 0 {
           let item = data?.data.myProject[indexPath.row]
            cell.img.af_setImage(withURL: URL(string: item!.image)!)
            cell.name.text = item?.name
            cell.info.text = item?.intro
            cell.zhichi.text = "支持 \(item?.support ?? "0")"
            cell.yichou.text = "已筹 \(item?.raise ?? "0")"
            cell.dacheng.text = "达成 \(item?.reach ?? "0")"
            let lv: CGFloat = CGFloat(CGFloat(Int(item?.reach ?? "0") ?? 0)/100.0)
            cell.line.frame = CGRect(x: 1, y: 1, width: cell.bg.frame.width*lv, height: 6)
        } else {
            let item = data?.data.otherProject[indexPath.row]
            cell.img.af_setImage(withURL: URL(string: item!.image)!)
            cell.name.text = item?.name
            cell.info.text = item?.intro
            cell.zhichi.text = "支持 \(item?.support ?? "0")"
            cell.yichou.text = "已筹 \(item?.raise ?? "0")"
            cell.dacheng.text = "达成 \(item?.reach ?? "0")"
            let lv: CGFloat = CGFloat(CGFloat(Int(item?.reach ?? "0") ?? 0)/100.0)
            cell.line.frame = CGRect(x: 1, y: 1, width: cell.bg.frame.width*lv, height: 6)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var id = ""
        if indexPath.section == 0 {
            id = data?.data.myProject[indexPath.row].id ?? ""
        } else {
            id = data?.data.otherProject[indexPath.row].id ?? ""
        }
        let detail = VipProductDetailViewController()
        detail.id = id
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
