//
//  RetrospectViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/18.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class RetrospectViewController: UIViewController {
    @IBOutlet weak var search: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        title = "产品追溯"
//        let titleView = UIView(frame: CGRect(x: 16, y: 10, width: view.frame.width - 70, height: 40))
        search.layer.cornerRadius = 20
//        titleView.backgroundColor = UIColor.lightColor

//        let seachText = UITextField(frame: CGRect(x: 10, y: 0, width: titleView.frame.size.width, height: 40))
        search.placeholder = "输入产品编号"
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
    }
}
extension RetrospectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 3
       }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RetrospectGoodsTableViewCell") as! RetrospectGoodsTableViewCell
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RetrospecTitleTableViewCell") as! RetrospecTitleTableViewCell
            cell.selectionStyle = .none
            return cell
        }
           let cell = tableView.dequeueReusableCell(withIdentifier: "RetrospecStoreTableViewCell") as! RetrospecStoreTableViewCell
           cell.selectionStyle = .none
           return cell
       }
}
