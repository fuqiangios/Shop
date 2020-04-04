//
//  HomeViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2019/12/25.
//  Copyright © 2019 付强. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

class HomeViewController: UIViewController {
    @IBOutlet weak var scrowView: UIScrollView!
    var data: Home? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .black
        setSearBar()
        setRightItem()
        setLeftItem()
        loadData()
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

    func setTypeSelectView() {
        let typeSelectView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        let types = data?.data.category ?? []
        for index in 0...types.count{
            if index == 0 {
                let btn = UIButton(type: .custom)
                btn.frame = CGRect(x: index*60, y: 0, width: 60, height: 40)
                btn.setTitle("精选", for: .normal)
                btn.setTitleColor(.black, for: .normal)
                btn.setTitleColor(.red, for: .selected)
                btn.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
                btn.tag = index + 100
                btn.addTarget(self, action: #selector(selectType(btn:)), for: .touchUpInside)
                if index == 0 {
                    btn.isSelected = true
                    btn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
                }
                typeSelectView.addSubview(btn)
            } else {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: index*60, y: 0, width: 60, height: 40)
            btn.setTitle(types[index - 1].name, for: .normal)
            btn.setTitleColor(.black, for: .normal)
            btn.setTitleColor(.red, for: .selected)
            btn.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
            btn.tag = index + 100
            btn.addTarget(self, action: #selector(selectType(btn:)), for: .touchUpInside)
            if index == 0 {
                btn.isSelected = true
                btn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
            }
            typeSelectView.addSubview(btn)
            }
        }
        typeSelectView.contentSize = CGSize(width: 60 * (types.count + 1), height: 40)
        typeSelectView.showsHorizontalScrollIndicator = false
        setChildView()

        view.addSubview(typeSelectView)
    }

    @objc func selectType(btn: UIButton) {
        setTopBtnNormal(button: btn)
        let wid = view.frame.size.width
        scrowView.contentOffset = CGPoint(x: CGFloat(btn.tag - 100) * wid, y: 0)
    }

    func setTopBtnNormal(button: UIButton) {
        let types = data?.data.category ?? []
        for index in 100..<(101+types.count) {
            let btn = view.viewWithTag(index) as! UIButton
            btn.isSelected = false
            btn.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
        }
        button.isSelected = true
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
    }

    func setChildView() {
        scrowView.bounces = false
        scrowView.isPagingEnabled = true
        scrowView.delegate = self
        let width = view.frame.size.width
        let height = ScreenHeight/896
        let types = data?.data.category ?? []
        for index in 0...types.count{
            if index == 0 {
                let selected = SelectedViewController()
                selected.data = data
                selected.didSelectCell = { [weak self] indexPath in
                    if indexPath.section == 6 {
                        let detail = GoodsDeatilViewController()
                        detail.hidesBottomBarWhenPushed = true
                        detail.product_id = self?.data?.data.labels[index].product[indexPath.item].id ?? ""
                        self?.navigationController?.pushViewController(detail, animated: true)
                        return
                    }
                    let goodsList = GoodsListViewController()
                    self?.navigationController?.pushViewController(goodsList, animated: true)
                }
                self.addChild(selected)
                let child = UIView(frame: CGRect(x: width * CGFloat(index), y: 0, width: width, height: 710*height))
                child.addSubview(selected.view)
                selected.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 710*height)
                selected.setView(ehigth: Float(710*height))
                scrowView.addSubview(child)
            } else {
                let recommend = RecommendTypeViewController(categoryId: types[index - 1].id)
                 self.addChild(recommend)
                recommend.didSelectCell = { [weak self] id in
                    let detail = GoodsDeatilViewController()
                    detail.hidesBottomBarWhenPushed = true
                    detail.product_id = id
                    self?.navigationController?.pushViewController(detail, animated: true)

                    }
                 let child = UIView(frame: CGRect(x: width * CGFloat(index), y: 0, width: width, height: 710*height))
                 child.addSubview(recommend.view)
                 recommend.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 710*height)
                 recommend.setView(ehigth: Float(710*height))
                 scrowView.addSubview(child)
            }
        }
        scrowView.contentSize = CGSize(width: view.frame.size.width * CGFloat(types.count + 1), height: 0)
    }

    func loadData() {
        API.homeData().request{ (result) in
            switch result {
            case .success(let home):
                self.data = home
                self.setTypeSelectView()
            case .failure(let error):
                self.setTypeSelectView()
                print(error)
                print(error.self)
                print(error.localizedDescription)
            }
        }
    }
}
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    //滑动结束后
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // 获得索引
        let index = scrollView.contentOffset.x / view.frame.size.width
        let btn = view.viewWithTag(Int(index+100))as!UIButton
        setTopBtnNormal(button: btn)
    }
}
