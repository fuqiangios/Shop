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
import CoreLocation

class HomeViewController: UIViewController,UITextFieldDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var scrowView: UIScrollView!
    var data: Home? = nil
    var shop = ""
    var latitudeStr = 0.00
    var longitudeStr = 0.00
    var isload = false
    var locationManager:CLLocationManager = CLLocationManager()
    var timer : Timer?
    var typeSelectView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updataSecond), userInfo: nil, repeats: true)
           timer!.fire()
        NotificationCenter.default.addObserver(self, selector: #selector(shouldPopup), name: NSNotification.Name(rawValue: "popup"), object: nil)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .black
//        title = ""
        navigationItem.title = ""
        let itme = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = itme
        reLocationAction()
        setSearBar()
        setRightItem()
         if(CLLocationManager.authorizationStatus() != .denied) {

         } else {
            let alt = UIAlertController(title: "我家有品", message: "为了帮您获取最近的店铺信息，建议您打开位置权限", preferredStyle: .alert)
            let cal = UIAlertAction(title: "关闭", style: .cancel) { (_) in
                self.loadData()
            }
            
            alt.addAction(cal)
            self.present(alt, animated: true, completion: nil)
        }
        loadData()
//        setLeftItem()
    }

    @objc func shouldPopup() {
        let popup = HomwPopUpViewController()
        popup.modalPresentationStyle = .custom
        self.present(popup, animated: false, completion: nil)
    }

    @objc func updataSecond() {
        if data == nil {
            loadData()
        }
        if UserSetting.default.activeUserToken == nil {
            return
        }
        API.checkToken(now_user_token: UserSetting.default.activeUserToken ?? "").request { (result) in
            switch result {
            case .success(let data):
                if data.data.effect == "0" {
                    let al = UIAlertView(title: "系统提示", message: "账号已在其它设备登录，如不是您本人操作，请立即修改密码", delegate: self, cancelButtonTitle: "好的")
                    al.show()
                    UserSetting.default.activeUserToken = nil
                    UserSetting.default.activeUserPhone = nil
                }
            case .failure(let er):
                                    let al = UIAlertView(title: "系统提示", message: "账号已在其它设备登录，如不是您本人操作，请立即修改密码", delegate: self, cancelButtonTitle: "好的")
                al.show()
                UserSetting.default.activeUserToken = nil
                UserSetting.default.activeUserPhone = nil
            }
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let sera = GoodsSearViewController()
        sera.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(sera, animated: true)
        return textField.resignFirstResponder()
    }

    func reLocationAction(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest//定位最佳
        locationManager.distanceFilter = 500.0//更新距离
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
    }
    func locationManager(_ manager: CLLocationManager,

                         didFinishDeferredUpdatesWithError error: Error?) {
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let thelocations:NSArray = locations as NSArray
        let location = thelocations.lastObject as! CLLocation
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        latitudeStr = latitude
        longitudeStr = longitude
        print(latitudeStr)
        print(longitudeStr)
        locationManager.stopUpdatingLocation()
        loadData()
        locationManager.stopUpdatingLocation()
    }

    func setRightItem() {
        let rightBtn = UIButton(type: .custom)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightBtn.setImage(UIImage(named: "消息"), for: .normal)
        rightBtn.contentHorizontalAlignment = .right
        rightBtn.addTarget(self, action: #selector(toMessage), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }

    @objc func toMessage() {
        let message = MessageViewController()
        message.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(message, animated: true)
    }

    func setLeftItem(str: String) {
        let leftBtn = UIButton(type: .custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        leftBtn.setTitle(str, for: .normal)
        leftBtn.setImage(UIImage(named: "定位"), for: .normal)
        leftBtn.setTitleColor(.black, for: .normal)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftBtn.addTarget(self, action: #selector(toShopList), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
    }

    @objc func toShopList() {
        let shoqp = StoreListViewController()
        shoqp.hidesBottomBarWhenPushed = true
        shoqp.shiop = shop
        shoqp.latitude = latitudeStr
        shoqp.longitude = longitudeStr
        shoqp.didSelectAddress = { (shop) in
            self.shop = shop
            self.setLeftItem(str: shop)
        }
        self.navigationController?.pushViewController(shoqp, animated: true)
    }

    func setSearBar() {
        let titleView = UIView(frame: CGRect(x: 16, y: 10, width: view.frame.width - 32, height: 40))
        titleView.layer.cornerRadius = 20
        titleView.backgroundColor = UIColor.lightColor

        let seachText = UITextField(frame: CGRect(x: 10, y: 0, width: titleView.frame.size.width, height: 40))
        seachText.placeholder = "搜索产品名称"
        seachText.font = UIFont.PingFangSCLightFont16
        seachText.delegate = self
        titleView.addSubview(seachText)

        view.addSubview(titleView)

    }

    func setTypeSelectView() {
//        if isload {return}
        if isload {
        typeSelectView.removeFromSuperview()
        }
        isload = true


        typeSelectView = UIScrollView(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: 40))
        let types = data?.data.category ?? []
        for index in 0...types.count{
            if index == 0 {
                let btn = UIButton(type: .custom)
                btn.frame = CGRect(x: index*60, y: 0, width: 60, height: 40)
                btn.setTitle("精选", for: .normal)
                btn.setTitleColor(.black, for: .normal)
                btn.setTitleColor(.red, for: .selected)
                btn.titleLabel?.font = UIFont.PingFangSCLightFont18
                btn.tag = index + 100
                btn.addTarget(self, action: #selector(selectType(btn:)), for: .touchUpInside)
                if index == 0 {
                    btn.isSelected = true
                    btn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 16)
                }
                typeSelectView.addSubview(btn)
            } else {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: index*60, y: 0, width: 60, height: 40)
            btn.setTitle(types[index - 1].name, for: .normal)
            btn.setTitleColor(.black, for: .normal)
            btn.setTitleColor(.red, for: .selected)
            btn.titleLabel?.font = UIFont.PingFangSCLightFont18
            btn.tag = index + 100
            btn.addTarget(self, action: #selector(selectType(btn:)), for: .touchUpInside)
            if index == 0 {
                btn.isSelected = true
                btn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)
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
            btn.titleLabel?.font = UIFont.PingFangSCLightFont18
        }
        button.isSelected = true
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)
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
                selected.didSelectCell = { [weak self] lablesIndex, indexPath in
                    if indexPath.section == 1 {
                        let detail = GoodsDeatilViewController()
                        detail.hidesBottomBarWhenPushed = true
                        detail.product_id = self?.data?.data.labels[lablesIndex].product[indexPath.item].id ?? ""
                        print(lablesIndex)
                        print(indexPath.item)
                        print(self?.data?.data.labels[lablesIndex])
                        self?.navigationController?.pushViewController(detail, animated: true)
                        return
                    } else {
                        if self?.data?.data.imageLabels[indexPath.item].type != "1" {
                            let goodsList = GoodsListViewController()
                                               goodsList.hidesBottomBarWhenPushed = true
                                               goodsList.title = self?.data?.data.imageLabels[indexPath.item].name ?? ""
                                             goodsList.label_code = self?.data?.data.imageLabels[indexPath.item].code ?? ""
                                               self?.navigationController?.pushViewController(goodsList, animated: true)
                        } else {
//                    UserSetting.default.activeType = indexPath.item
//                    self?.tabBarController?.selectedIndex = 1
                            let goodsList = GoodsListViewController()
                              goodsList.hidesBottomBarWhenPushed = true
                              goodsList.title = self?.data?.data.imageLabels[indexPath.item].name ?? ""
                            goodsList.p_category_id = self?.data?.data.imageLabels[indexPath.item].id ?? ""
                              self?.navigationController?.pushViewController(goodsList, animated: true)
                        }
                    }

//
//                    let goodsList = GoodsListViewController()
//                    goodsList.hidesBottomBarWhenPushed = true
//                    goodsList.title = self?.data?.data.category[indexPath.item].name ?? ""
//                    goodsList.label_code = self?.data?.data.category[indexPath.item].id ?? ""
//                    self?.navigationController?.pushViewController(goodsList, animated: true)
                }
                self.addChild(selected)
                let child = UIView(frame: CGRect(x: width * CGFloat(index), y: 0, width: width, height: 710*height))
                child.addSubview(selected.view)
                selected.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 650*height)
                selected.setView(ehigth: Float(650*height))
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
                 recommend.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 650*height)
                 recommend.setView(ehigth: Float(650*height))
                 scrowView.addSubview(child)
            }
        }
        scrowView.contentSize = CGSize(width: view.frame.size.width * CGFloat(types.count + 1), height: 0)
    }

    func loadData() {
        API.homeData(longitude: "\(longitudeStr)", latitude: "\(latitudeStr)").request{ (result) in
            switch result {
            case .success(let home):
                self.data = home

                self.shop = "\(self.data?.data.shop.cityName ?? "") \(self.data?.data.shop.name ?? "")"
                self.setLeftItem(str: self.shop)
                self.setTypeSelectView()
            case .failure(let error):
                let alt = UIAlertController(title: "我家有品", message: "为了帮您获取最近的店铺信息，建议您打开位置以及无线数据权限", preferredStyle: .alert)
                let sht = UIAlertAction(title: "打开了", style: .destructive) { (_) in
                    self.loadData()
                }
                let cal = UIAlertAction(title: "关闭", style: .cancel) { (_) in
                }
                alt.addAction(sht)
                alt.addAction(cal)
                self.present(alt, animated: true, completion: nil)
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
