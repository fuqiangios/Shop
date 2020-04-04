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

    @IBOutlet weak var floatView: UIView!
    @IBOutlet weak var bottomTagListView: TagListView!
    @IBOutlet weak var topTagListView: TagListView!
    @IBOutlet weak var addCardBtn: UIButton!
    @IBOutlet weak var bugBtn: UIButton!
    @IBOutlet weak var goodsImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var detail: UILabel!

    var data: GoodsDetail? = nil
    var topTagSelectIndex: String? = ""
    var bottomTagSelectIndex: String? = ""
    var topId: String? = ""
    var bottomId: String? = ""
    var numCnt: Int = 1
    @IBOutlet weak var jia: UIButton!
    var didToBuy: ((String,String) -> Void)?

    @IBOutlet weak var numText: UITextField!
    @IBOutlet weak var jian: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setCommentView()
    }
    
    func setUp() {
        bugBtn.layer.cornerRadius = 5
        bugBtn.layer.masksToBounds = true

        addCardBtn.layer.borderColor = bugBtn.backgroundColor?.cgColor
        addCardBtn.layer.borderWidth = 1
        addCardBtn.layer.cornerRadius = 5
        addCardBtn.layer.masksToBounds = true
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
        topTagListView.tagBackgroundColor = UIColor.init(red: 224.0/255.0, green: 227.0/255.0, blue: 233.0/255.0, alpha: 1)
        topTagListView.textColor = .black
        topTagListView.borderColor = UIColor.init(red: 224.0/255.0, green: 227.0/255.0, blue: 233.0/255.0, alpha: 1)
        topTagListView.selectedTextColor = .white
        topTagListView.tagSelectedBackgroundColor = .red
        topTagListView.tag = 909

        for item in data?.data.getProductOptionGroup()[0].productOption ?? [] {
            topTagListView.addTag("\(item.name)")
        }


        bottomTagListView.delegate = self
        bottomTagListView.textFont = .systemFont(ofSize: 15)
//        bottomTagListView.shadowRadius = 2
//        bottomTagListView.shadowOpacity = 0.4
//        bottomTagListView.shadowColor = UIColor.black
//        bottomTagListView.shadowOffset = CGSize(width: 1, height: 1)
        bottomTagListView.tagBackgroundColor = UIColor.init(red: 224.0/255.0, green: 227.0/255.0, blue: 233.0/255.0, alpha: 1)
        bottomTagListView.textColor = .black
        bottomTagListView.borderColor = UIColor.init(red: 224.0/255.0, green: 227.0/255.0, blue: 233.0/255.0, alpha: 1)
        bottomTagListView.selectedTextColor = .white
        bottomTagListView.tagSelectedBackgroundColor = .red
        bottomTagListView.tag = 808
        for item in data?.data.getProductOptionGroup()[1].productOption ?? [] {
            bottomTagListView.addTag("\(item.name)")
        }
    }
    
    @IBAction func jiaAction(_ sender: Any) {
        numCnt = numCnt + 1
        setNumText()
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
        API.addCart(product_id: data?.data.product.id ?? "", quantity: "\(numCnt)", product_option_union_id: "\(topTagSelectIndex ?? ""):\(bottomTagSelectIndex ?? "")").request { (result) in
            switch result {
            case .success:
                NotificationCenter.default.post(name: NSNotification.Name("notificationCreatOrder"), object: self, userInfo: [:])
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                print(error)
                print(error.self)
                print(error.localizedDescription)
            }
        }
    }

    
    @IBAction func goToBuy(_ sender: Any) {
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

