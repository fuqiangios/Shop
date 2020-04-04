//
//  TypeViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2019/12/25.
//  Copyright © 2019 付强. All rights reserved.
//

import UIKit
import ZLCollectionViewFlowLayout

class TypeViewController: UIViewController, ZLCollectionViewBaseFlowLayoutDelegate {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var collectionView: UICollectionView!
    var data: TypeList? = nil
    var selectIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "商品分类"
        self.navigationController?.navigationBar.tintColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "TypeTableViewCell", bundle: nil), forCellReuseIdentifier: "type")
        setCollectionView()
        loadData()
    }

    func setCollectionView()  {
        let layout = ZLCollectionViewVerticalLayout()
        layout.delegate = self

        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        // 注册cell
        collectionView?.register(UINib.init(nibName: "TypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "typecollection")
    }

    func loadData() {
        API.typeList().request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
                print(error.self)
                print(error.localizedDescription)
            }
        }
    }
}
extension TypeViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "type") as! TypeTableViewCell
        cell.name.text = data?.data[indexPath.row].name
        cell.selectionStyle = .none
        if indexPath.row == selectIndex {
            cell.backgroundColor = .white
            cell.name.textColor = .red
        } else {
            cell.backgroundColor = .groupTableViewBackground
            cell.name.textColor = cell.name.tintColor
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.item
        collectionView.reloadData()
        tableView.reloadData()
    }
}

extension TypeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.data[selectIndex].category.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TypeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "typecollection", for: indexPath) as! TypeCollectionViewCell
        cell.name.text = data?.data[selectIndex].category[indexPath.row].name
        cell.img.af_setImage(withURL: URL(string: (data?.data[selectIndex].category[indexPath.row].getImg())!)!)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 24)/2, height: (collectionView.frame.size.width)/2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets.init(top: 0, left: 6, bottom: 0, right: 6)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let list = GoodsListViewController()
        list.category_id = data?.data[selectIndex].category[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(list, animated: true)
    }
}
