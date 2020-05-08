//
//  SelectTypeViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/1/10.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import TagListView

class SelectTypeViewController: UIViewController {

    @IBOutlet weak var bottoName: UILabel!
    @IBOutlet weak var topName: UILabel!
    @IBOutlet weak var floatView: UIView!
    @IBOutlet weak var bottomTagListView: TagListView!
    @IBOutlet weak var topTagListView: TagListView!
    @IBOutlet weak var addCardBtn: UIButton!
    @IBOutlet weak var bugBtn: UIButton!
    @IBOutlet weak var goodsImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var close: UIButton!

    var data: GoodsDetail? = nil
    var topTagSelectIndex: String? = ""
    var bottomTagSelectIndex: String? = ""
    var topId: String? = ""
    var bottomId: String? = ""
    var numCnt: Int = 1
    @IBOutlet weak var jia: UIButton!
    var didToBuy: ((String,String) -> Void)?
    var didColse: ((String) -> Void)?

    @IBOutlet weak var numText: UITextField!
    @IBOutlet weak var jian: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        getGoodsInfo()
        setUp()
        setCommentView()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
    }
    
    func setUp() {
//        bugBtn.layer.cornerRadius = 5
//        bugBtn.layer.masksToBounds = true

        numText.layer.borderWidth = 1
        numText.layer.borderColor = UIColor.lightColor.cgColor

//        addCardBtn.layer.borderColor = bugBtn.backgroundColor?.cgColor
//        addCardBtn.layer.borderWidth = 1
//        addCardBtn.layer.cornerRadius = 5
//        addCardBtn.layer.masksToBounds = true
        floatView.layer.cornerRadius = 5
        floatView.layer.masksToBounds = true

        goodsImage.af_setImage(withURL: URL(string: (data?.data.product.image)!)!)
    }

    func setCommentView() {
        topTagListView.delegate = self
        topTagListView.textFont = .systemFont(ofSize: 15)
//        topTagListView.shadowRadius = 2
//        topTagListView.shadowOpacity = 0.4
//        topTagListView.shadowColor = UIColor.black
//        topTagListView.shadowOffset = CGSize(width: 1, height: 1)
        topTagListView.tagBackgroundColor = UIColor.white
        topTagListView.selectedBorderColor = UIColor.lightColor
        topTagListView.textColor = UIColor.blackTextColor
        topTagListView.borderColor = UIColor.lightColor
        topTagListView.selectedTextColor = .red
        topTagListView.selectedBorderColor = .red
        topTagListView.tag = 909

        for item in data?.data.getProductOptionGroup()[0].productOption ?? [] {
            topTagListView.addTag("\(item.name)")
        }

        if (data?.data.getProductOptionGroup()[0].productOption ?? []).count == 0 {
            topName.text = ""
        } else {
            topName.text = data?.data.getProductOptionGroup()[0].name ?? ""
        }


        bottomTagListView.delegate = self
        bottomTagListView.textFont = .systemFont(ofSize: 15)
//        bottomTagListView.shadowRadius = 2
//        bottomTagListView.shadowOpacity = 0.4
//        bottomTagListView.shadowColor = UIColor.black
//        bottomTagListView.shadowOffset = CGSize(width: 1, height: 1)
        bottomTagListView.tagBackgroundColor = UIColor.white
        bottomTagListView.selectedBorderColor = UIColor.lightColor
        bottomTagListView.textColor = UIColor.blackTextColor
        bottomTagListView.borderColor = UIColor.lightColor
        bottomTagListView.selectedTextColor = .red
//        bottomTagListView.tagSelectedBackgroundColor = .red
        bottomTagListView.selectedBorderColor = .red
        bottomTagListView.tag = 808
        for item in data?.data.getProductOptionGroup()[1].productOption ?? [] {
            bottomTagListView.addTag("\(item.name)")
        }
        if (data?.data.getProductOptionGroup()[1].productOption ?? []).count == 0 {
            bottoName.text = ""
        } else {
            bottoName.text = data?.data.getProductOptionGroup()[1].name ?? ""
        }
    }
    
    @IBAction func jiaAction(_ sender: Any) {
        numCnt = numCnt + 1
        setNumText()
    }

    @IBAction func close(_ sender: Any) {
        didColse?("\(topTagSelectIndex ?? ""):\(bottomTagSelectIndex ?? "")")
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func jianAction(_ sender: Any) {
        if numCnt <= 1 {
            setNumText()
            return
        }
        numCnt = numCnt - 1
        setNumText()
    }

    func setNumText() {
        numText.text = "\(numCnt)"
    }
    

    @IBAction func addCart(_ sender: Any) {
        if UserSetting.default.activeUserToken == nil {
        let login = LoginViewController()
        self.navigationController?.pushViewController(login, animated: true)
            return
        }
        var bi = false
        if (data?.data.productOptionGroup ?? []).count == 0 {
            bi = true
            if data?.data.product.stock == "0" {
                CLProgressHUD.showError(in: view, delegate: self, title: "库存不足", duration: 1)
                return
            }
        } else if (data?.data.productOptionGroup ?? []).count == 1 {
            if topTagSelectIndex == "" {
                bi = false
            } else {
            bi = true
            }
        } else if  (data?.data.productOptionGroup ?? []).count == 2 {
                   if topTagSelectIndex == "" {
                       bi = false
                   }else if bottomTagSelectIndex == "" {
                    bi = false
                   }else {
                   bi = true
                   }
        }
        if !bi {
            CLProgressHUD.showError(in: view, delegate: self, title: "请选择商品类型", duration: 1)
            return
        }
        for item in data?.data.union ?? [] {
            if item.productUnion == "\(topTagSelectIndex ?? ""):\(bottomTagSelectIndex ?? "")" {
                if Int(item.stock) ?? 0 <= 0 {
                    CLProgressHUD.showError(in: view, delegate: self, title: "库存不足", duration: 1)
                    return
                }
            }
        }
        var tr = ""
        for item in data?.data.union ?? []{
            if (data?.data.productOptionGroup ?? []).count == 2 {
            if item.productUnion == "\(topTagSelectIndex ?? ""):\(bottomTagSelectIndex ?? "")" {
                tr = item.id
            }
            } else {
                if item.productUnion == "\(topTagSelectIndex ?? "")" {
                     tr = item.id
                 }
            }
        }

        API.addCart(product_id: data?.data.product.id ?? "", quantity: "\(numCnt)", product_option_union_id: tr).request { (result) in
            switch result {
            case .success:
                NotificationCenter.default.post(name: NSNotification.Name("notificationCreatOrder"), object: self, userInfo: [:])
                CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "加入购物车成功", duration: 1)
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                CLProgressHUD.showError(in: self.view, delegate: self, title: "加入购物车失败", duration: 1)
                print(error)
                print(error.self)
                print(error.localizedDescription)
            }
        }
    }

    
    @IBAction func goToBuy(_ sender: Any) {
        if UserSetting.default.activeUserToken == nil {
        let login = LoginViewController()
        self.navigationController?.pushViewController(login, animated: true)
            return
        }
        var bi = false
        if (data?.data.productOptionGroup ?? []).count == 0 {
            if data?.data.product.stock == "0" {
                CLProgressHUD.showError(in: view, delegate: self, title: "库存不足", duration: 1)
                return
            }
            bi = true
        } else if (data?.data.productOptionGroup ?? []).count == 1 {
            if topTagSelectIndex == "" {
                bi = false
            } else {
            bi = true
            }
        } else if  (data?.data.productOptionGroup ?? []).count == 2 {
                   if topTagSelectIndex == "" {
                       bi = false
                   }else if bottomTagSelectIndex == "" {
                    bi = false
                   }else {
                   bi = true
                   }
               }
        if !bi {
            CLProgressHUD.showError(in: view, delegate: self, title: "请选择商品类型", duration: 1)
            return
        }
        for item in data?.data.union ?? [] {
            if item.productUnion == "\(topTagSelectIndex ?? ""):\(bottomTagSelectIndex ?? "")" {
                if Int(item.stock) ?? 0 <= 0 {
                    CLProgressHUD.showError(in: view, delegate: self, title: "库存不足", duration: 1)
                    return
                }
            }
        }
        didToBuy?("\(numCnt)","\(topTagSelectIndex ?? ""):\(bottomTagSelectIndex ?? "")")
        self.dismiss(animated: true, completion: nil)
    }
}

extension SelectTypeViewController: TagListViewDelegate{
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if sender.tag == 909 {
            topTagView()
            if tagView.isSelected == false {
                for item in data?.data.getProductOptionGroup()[0].productOption ?? [] {
                    if item.name == title {
                        topTagSelectIndex = item.id
                    }
                }
            }
        } else {
            bottomTagView()
            if tagView.isSelected == false {
                for item in data?.data.getProductOptionGroup()[1].productOption ?? [] {
                    if item.name == title {
                        bottomTagSelectIndex = item.id
                    }
                }
            }
        }
        getGoodsInfo()
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
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

    func getGoodsInfo() {
        if data?.data.union.count == 0 {
            price.text = "￥\(data?.data.product.price ?? "")"
            detail.text = data?.data.product.name
        }
        for item in data?.data.union ?? []{
            if item.productUnion == "\(topTagSelectIndex ?? ""):\(bottomTagSelectIndex ?? "")" {
                price.text = "￥\(item.price)"
                detail.text = item.productUnionName
            }
        }
    }

    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
}

