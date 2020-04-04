//
//  GoodsListViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/3.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class GoodsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var data: CategoryList? = nil
    var category_id: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearBar()
        setRightItem()
        setLeftItem()
        setTableView()
        loadData()
    }

    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "GoodsListTableViewCell", bundle: nil), forCellReuseIdentifier: "goodsList")
    }

    func setRightItem() {
        let rightBtn = UIButton(type: .custom)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightBtn.setImage(UIImage(named: "Oval_normal"), for: .normal)
        rightBtn.contentHorizontalAlignment = .right

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }

    func setLeftItem() {
        let leftBtn = UIButton(type: .custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        leftBtn.setTitle("高新区门店高", for: .normal)
        leftBtn.setImage(UIImage(named: "map-marker"), for: .normal)
        leftBtn.setTitleColor(.black, for: .normal)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
    }

    func setSearBar() {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        titleView.layer.borderColor = UIColor.black.cgColor
        titleView.layer.borderWidth = 0.5
        titleView.layer.masksToBounds = true
        titleView.layer.cornerRadius = 10

        let seachText = UITextField(frame: CGRect(x: 10, y: 0, width: titleView.frame.size.width, height: 30))
        seachText.placeholder = "搜索商品"
        seachText.font = UIFont.systemFont(ofSize: 14)
        titleView.addSubview(seachText)

        self.navigationItem.titleView = titleView
    }

    func loadData() {
        API.homeCategoryData(p_category_id: nil, category_id: "10")
            .request { (result) in
                switch result {
                case .success(let data):
                    self.data = data
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                    print(error.self)
                    print(error.localizedDescription)
                }
        }
    }
}
extension GoodsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.products.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goodsList") as! GoodsListTableViewCell
        let item = data?.data.products[indexPath.row]
        cell.nameLabel.text = item?.name ?? ""
        cell.priceLabel.text = "￥\(item?.price ?? "0")  \(item?.saleCnt ?? "0")人付款"
        cell.img.af_setImage(withURL: URL(string: item!.image)!)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = GoodsDeatilViewController()
        detail.hidesBottomBarWhenPushed = true
        detail.product_id = data?.data.products[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
