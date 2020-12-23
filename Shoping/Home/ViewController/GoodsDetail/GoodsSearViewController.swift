//
//  GoodsSearViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/25.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import TagListView

class GoodsSearViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var btn: UIButton!
    var data: Search? = nil
    
    @IBOutlet weak var bottomTagListView: TagListView!
    @IBOutlet weak var topTagListView: TagListView!
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var searchView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "搜索"
        searchView.layer.cornerRadius = 20
        searchView.layer.masksToBounds = true
        search.setValue(UIColor.black, forKeyPath: "placeholderLabel.textColor")
        search.textColor = .black
        search.delegate = self
        let left = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        left.image = UIImage(named: "search")
        search.leftView = left
        search.leftViewMode = .always

        btn.layer.cornerRadius = 35/2
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = btn.titleLabel?.textColor.cgColor
        btn.addTarget(self, action: #selector(clearSearchHistory), for: .touchUpInside)
        loadData()
    }

    func loadData() {
        API.searchData().request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.setCommentView()
            case .failure(let er):
                print(er)
            }
        }
    }

    @objc func clearSearchHistory() {
        UserSetting.default.searchHistory = nil
        setCommentView()
    }

    func setCommentView() {
        topTagListView.removeAllTags()
            topTagListView.delegate = self
            topTagListView.textFont = .systemFont(ofSize: 15)
            topTagListView.tagBackgroundColor = UIColor.lightColor
            topTagListView.selectedBorderColor = UIColor.lightColor
            topTagListView.textColor = UIColor.blackTextColor
            topTagListView.borderColor = UIColor.lightColor
            topTagListView.selectedTextColor = UIColor.blackTextColor
            topTagListView.tagSelectedBackgroundColor = UIColor.lightColor
            topTagListView.selectedBorderColor = UIColor.lightColor
            topTagListView.tag = 909
        topTagListView.backgroundColor = .white

        for index in data?.data ?? [] {
                topTagListView.addTag("\(index)")
            }

        bottomTagListView.removeAllTags()
            bottomTagListView.delegate = self
            bottomTagListView.textFont = .systemFont(ofSize: 15)
            bottomTagListView.tagBackgroundColor = UIColor.lightColor
            bottomTagListView.selectedBorderColor = UIColor.lightColor
            bottomTagListView.textColor = UIColor.blackTextColor
            bottomTagListView.borderColor = UIColor.lightColor
            bottomTagListView.selectedTextColor = UIColor.blackTextColor
            bottomTagListView.tagSelectedBackgroundColor = UIColor.lightColor
            bottomTagListView.selectedBorderColor = UIColor.lightColor
            bottomTagListView.tag = 808
        bottomTagListView.backgroundColor = .white
        for item in UserSetting.default.searchHistory ?? []{
            bottomTagListView.addTag(item)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var ar = UserSetting.default.searchHistory
           if ar == nil {
               ar = [textField.text ?? ""]
           } else {
               ar?.append(textField.text ?? "")
           }
           if textField.text?.isEmpty ?? true {return false}
           UserSetting.default.searchHistory = ar
           setCommentView()
            textField.resignFirstResponder()

        let list = GoodsListViewController()
        list.keyWord = textField.text ?? ""
        list.title = "搜索商品"
        self.navigationController?.pushViewController(list, animated: true)
            return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

    }

}
extension GoodsSearViewController: TagListViewDelegate{
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if sender.tag == 909 {
//            topTagView()
        } else {
//            bottomTagView()
        }
        print("Tag pressed: \(title), \(sender)")
//        tagView.isSelected = !tagView.isSelected
        let list = GoodsListViewController()
        list.keyWord = title
        list.title = "搜索商品"
        self.navigationController?.pushViewController(list, animated: true)
    }

    func topTagView() {
        for item in topTagListView.tagViews {
            item.isSelected = false
        }
    }

    func bottomTagView() {
        for item in bottomTagListView.tagViews {
            item.isSelected = false
        }
    }

    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
}
