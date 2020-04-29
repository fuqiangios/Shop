//
//  TypeViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2019/12/25.
//  Copyright © 2019 付强. All rights reserved.
//

import UIKit
import ZLCollectionViewFlowLayout

class TypeViewController: UIViewController, ZLCollectionViewBaseFlowLayoutDelegate, UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var collectionView: UICollectionView!
    var data: TypeList? = nil
    var selectIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        let itme = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = itme

        setSearBar()
//                        if #available(iOS 11.0, *) {
//        //                    self.navigationController?.navigationBar.prefersLargeTitles = true
//                            let mySearchController: UISearchController = UISearchController(searchResultsController: nil)
//                //            mySearchController.searchResultsUpdater = self
//                            self.navigationItem.searchController = mySearchController
//                        } else {
//                            // Fallback on earlier versions
//                        }
        title = "分类"
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

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let sera = GoodsSearViewController()
        sera.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(sera, animated: true)
        return textField.resignFirstResponder()
    }

    func setSearBar() {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))

        titleView.backgroundColor = UIColor.white

        let seachText = UITextField(frame: CGRect(x: 20, y: 10, width: titleView.frame.size.width - 40, height: 40))
        seachText.placeholder = "  搜索产品名称"
        seachText.delegate = self
        seachText.layer.cornerRadius = 20
        seachText.backgroundColor = UIColor.lightColor
        seachText.font = UIFont.PingFangSCLightFont16
        titleView.addSubview(seachText)

        view.addSubview(titleView)

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
//            cell.backgroundColor = .white
//            cell.name.textColor = .red
            cell.line.isHidden = false
        } else {
//            cell.backgroundColor = .groupTableViewBackground
//            cell.name.textColor = cell.name.tintColor
            cell.line.isHidden = true
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
        return CGSize(width: (collectionView.frame.size.width - 30)/3, height: (collectionView.frame.size.width)/3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 8
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let list = GoodsListViewController()
        list.hidesBottomBarWhenPushed = true
        list.title = data?.data[selectIndex].category[indexPath.row].name ?? ""
        list.category_id = data?.data[selectIndex].category[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(list, animated: true)
    }
}
