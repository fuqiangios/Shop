//
//  MineViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2019/12/25.
//  Copyright © 2019 付强. All rights reserved.
//

import UIKit

class MineViewController: UIViewController {
    var data: MineInfo? = nil
    @IBOutlet weak var tableView: UITableView!
    var code = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        API.getUStatus().request { (result) in
            switch result {
            case .success(let data):
                self.code = data.data.code
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.isTranslucent = false
        let itme = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = itme
        setUp()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(shouldPopup), name: NSNotification.Name(rawValue: "popup"), object: nil)
    }

    @objc func shouldPopup() {
        self.tabBarController?.selectedIndex = 0
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        loadData()
    }

    @objc func toMessage() {
        let message = MessageViewController()
        message.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(message, animated: true)
    }

    @objc func toBarCode() {
        if UserSetting.default.activeUserToken == nil {
        let login = LoginViewController()
            login.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(login, animated: true)
            return
        }
        let pay = BarCodeViewController()
        pay.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(pay, animated: true)
    }

    func loadData()  {
        API.mineData().request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                if data.data.had_take_red == "0" {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "popup"), object: "")
                    self.tabBarController?.selectedIndex = 0
                }
                UserSetting.default.activeUserPhone = data.data.telephone
                self.tableView.reloadData()
            case .failure(let er):
                self.data = nil
                UserSetting.default.activeUserPhone = nil
                self.tableView.reloadData()
                print(er)
            }
        }
    }


    func setUp() {
        tableView.register(UINib(nibName: "MineHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "MineHeaderTableViewCell")
        tableView.register(UINib(nibName: "MineOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "MineOrderTableViewCell")
        tableView.register(UINib(nibName: "MineImgTableViewCell", bundle: nil), forCellReuseIdentifier: "MineImgTableViewCell")
        tableView.register(UINib(nibName: "MinToolTableViewCell", bundle: nil), forCellReuseIdentifier: "MinToolTableViewCell")
        tableView.register(UINib(nibName: "MineRedTableViewCell", bundle: nil), forCellReuseIdentifier: "MineRedTableViewCell")
        tableView.delegate = self
        tableView.backgroundColor = UIColor.tableviewBackgroundColor
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.bounces = false
        if #available(iOS 11.0, *) {
        tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        }
        else
        {
        self.automaticallyAdjustsScrollViewInsets = false;
        }
        view.addSubview(tableView)
    }

    @objc func myprice(btn: UIButton) {
        if UserSetting.default.activeUserToken == nil {
        let login = LoginViewController()
            login.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(login, animated: true)
            return
        }
        if btn.tag == 666 {
            let inte = IntegralViewController()
            inte.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(inte, animated: true)
        } else if btn.tag == 667 {
            let red = RedPackgeViewController()
            red.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(red, animated: true)
        } else if btn.tag == 668 {
            let amount = BalanceViewController()
            amount.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(amount, animated: true)
        } else if btn.tag == 669 {
            let discount = DiscountViewController()
            discount.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(discount, animated: true)
        }
    }

    @objc func toolAction(btn: UIButton) {
        if UserSetting.default.activeUserToken == nil {
        let login = LoginViewController()
            login.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(login, animated: true)
            return
        }
        if btn.tag == 401 {
            let chong = BalanceChongViewController()
            chong.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(chong, animated: true)
        } else if btn.tag == 402 {
            let favorite = FavoriteViewController()
            favorite.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(favorite, animated: true)
        } else if btn.tag == 403 {
            let address = AddressListViewController()
            address.hidesBottomBarWhenPushed = true
            address.up = "10"
            self.navigationController?.pushViewController(address, animated: true)
        } else if btn.tag == 404 {
            let eva = EvaluateManagerViewController()
            eva.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(eva, animated: true)
        } else if btn.tag == 501 {
            if code == "0" {
                            let account = AccountInfoViewController()
                account.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(account, animated: true)
            } else {
                           let sb=UIStoryboard.init(name: "Main", bundle: nil)

                let infovc = sb.instantiateViewController(withIdentifier: "NewVipViewController") as! NewVipViewController
                infovc.hidesBottomBarWhenPushed = true

                self.navigationController?.pushViewController(infovc, animated: true)
            }

        }
        else if btn.tag == 502 {
            if code == "0" {
             toBarCode()
            } else {
            let user = UserVipViewController()
            user.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(user, animated: true)
            }
        } else if btn.tag == 503 {
            let ach = AchievementViewController()
            ach.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(ach, animated: true)
        } else if btn.tag == 505 {
                   let retrospec = MyProductViewController()
                   retrospec.hidesBottomBarWhenPushed = true
                   self.navigationController?.pushViewController(retrospec, animated: true)
        } else if btn.tag == 504 {
            let retrospec = RetrospectViewController()
            retrospec.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(retrospec, animated: true)
        } else if btn.tag == 601 {
            let share = ShareViewController()
            share.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(share, animated: true)
        } else if btn.tag == 602 {
            let web = WebViewController()
            web.uri = "https://app.necesstore.com/html/help.html"
            web.title = "帮助中心"
            web.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(web, animated: true)
        } else if btn.tag == 603 {
            let web = WebViewController()
            web.uri = "https://app.necesstore.com/html/about.html"
            web.title = "关于我们"
            web.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(web, animated: true)
        } else if btn.tag == 604 {
            let setting = SettingViewController()
            setting.phone = self.data?.data.telephone ?? ""
            setting.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(setting, animated: true)
        }
    }
}

extension MineViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineHeaderTableViewCell") as! MineHeaderTableViewCell
            cell.btn.addTarget(self, action: #selector(toAccount), for: .touchUpInside)
            cell.name.text = data?.data.name ?? "点击登录"
            if !(data?.data.image.isEmpty ?? true) {
            cell.img.af_setImage(withURL: URL(string: data?.data.image ?? "")!)
            } else {
                cell.img.image = UIImage(named: "27211590459319_.pic_hd")
            }
            cell.message.addTarget(self, action: #selector(toMessage), for: .touchUpInside)
            cell.barCode.addTarget(self, action: #selector(toBarCode), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineOrderTableViewCell") as! MineOrderTableViewCell
            cell.payBtn.tag = 1
            cell.payBtn.addTarget(self, action: #selector(runOrderVc(btn:)), for: .touchUpInside)
            cell.deliverBtn.tag = 2
            cell.deliverBtn.addTarget(self, action: #selector(runOrderVc(btn:)), for: .touchUpInside)
            cell.receivingBtn.tag = 3
            cell.receivingBtn.addTarget(self, action: #selector(runOrderVc(btn:)), for: .touchUpInside)
            cell.evaluateBtn.tag = 4
            cell.evaluateBtn.addTarget(self, action: #selector(runOrderVc(btn:)), for: .touchUpInside)
            cell.returnBtn.tag = 6
            cell.returnBtn.addTarget(self, action: #selector(runOrderVc(btn:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineImgTableViewCell") as! MineImgTableViewCell
            cell.selectionStyle = .none
            cell.btn.addTarget(self, action: #selector(tocheck), for: .touchUpInside)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MineRedTableViewCell") as! MineRedTableViewCell
            cell.selectionStyle = .none
            cell.point.setTitle(data?.data.shortPoints ?? "0", for: .normal)
            cell.redpackg.setTitle(data?.data.redPackage ?? "0", for: .normal)
            cell.price.setTitle(data?.data.amount ?? "0", for: .normal)
            cell.discount.setTitle("\(data?.data.couponCount ?? 0)", for: .normal)
                        cell.point.addTarget(self, action: #selector(myprice(btn:)), for: .touchUpInside)
                        cell.redpackg.addTarget(self, action: #selector(myprice(btn:)), for: .touchUpInside)
                        cell.price.addTarget(self, action: #selector(myprice(btn:)), for: .touchUpInside)
                        cell.discount.addTarget(self, action: #selector(myprice(btn:)), for: .touchUpInside)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MinToolTableViewCell") as! MinToolTableViewCell
        cell.selectionStyle = .none
        if indexPath.section == 4 {
            cell.btn1.setTitle("快速充值", for: .normal)
            cell.btn1.setImage(UIImage(named: "快速充值"), for: .normal)
            cell.btn2.setTitle("我的收藏", for: .normal)
            cell.btn2.setImage(UIImage(named: "收藏"), for: .normal)
            cell.btn3.setTitle("地址管理", for: .normal)
            cell.btn3.setImage(UIImage(named: "地址管理"), for: .normal)
            cell.btn4.setTitle("评论管理", for: .normal)
            cell.btn4.setImage(UIImage(named: "评论管理"), for: .normal)
            cell.name.text = "商城工具"
            cell.btn1.tag = indexPath.section*100 + 1
            cell.btn2.tag = indexPath.section*100 + 2
            cell.btn3.tag = indexPath.section*100 + 3
            cell.btn4.tag = indexPath.section*100 + 4
            cell.btn5.isHidden = true
            cell.btn1.addTarget(self, action: #selector(toolAction(btn:)), for: .touchUpInside)
            cell.btn2.addTarget(self, action: #selector(toolAction(btn:)), for: .touchUpInside)
            cell.btn3.addTarget(self, action: #selector(toolAction(btn:)), for: .touchUpInside)
            cell.btn4.addTarget(self, action: #selector(toolAction(btn:)), for: .touchUpInside)
            cell.btn5.isHidden = true
        } else if indexPath.section == 5 {
            if code == "0" {
                cell.btn1.setTitle("个人信息", for: .normal)
                cell.btn1.setImage(UIImage(named: "会员"), for: .normal)
                cell.btn2.setTitle("结算码", for: .normal)
                cell.btn2.setImage(UIImage(named: "vip"), for: .normal)
            } else {
                cell.btn1.setTitle("VIP", for: .normal)
                cell.btn1.setImage(UIImage(named: "vip"), for: .normal)
                cell.btn2.setTitle("会员信息", for: .normal)
                cell.btn2.setImage(UIImage(named: "会员"), for: .normal)
            }

            cell.btn3.setTitle("连锁店业绩", for: .normal)
            cell.btn3.setImage(UIImage(named: "业绩"), for: .normal)
            cell.btn4.setTitle("产品追溯", for: .normal)
            cell.btn4.setImage(UIImage(named: "产品追溯"), for: .normal)
            cell.btn5.setTitle("我的项目", for: .normal)
            cell.btn5.setImage(UIImage(named: "我的项目"), for: .normal)
            cell.name.text = "信息查询"
            cell.btn1.tag = indexPath.section*100 + 1
            cell.btn2.tag = indexPath.section*100 + 2
            cell.btn3.tag = indexPath.section*100 + 3
            cell.btn4.tag = indexPath.section*100 + 4
            cell.btn5.tag = indexPath.section*100 + 5
            if code == "0" {
                 cell.btn5.isHidden = true
             } else {
                 cell.btn5.isHidden = false
             }
            cell.btn1.addTarget(self, action: #selector(toolAction(btn:)), for: .touchUpInside)
            cell.btn2.addTarget(self, action: #selector(toolAction(btn:)), for: .touchUpInside)
            cell.btn3.addTarget(self, action: #selector(toolAction(btn:)), for: .touchUpInside)
            cell.btn4.addTarget(self, action: #selector(toolAction(btn:)), for: .touchUpInside)
            cell.btn5.addTarget(self, action: #selector(toolAction(btn:)), for: .touchUpInside)
        } else if indexPath.section == 6 {
            cell.btn1.setTitle("邀请推荐", for: .normal)
            cell.btn1.setImage(UIImage(named: "邀请推荐"), for: .normal)
            cell.btn2.setTitle("帮助中心", for: .normal)
            cell.btn2.setImage(UIImage(named: "帮助"), for: .normal)
            cell.btn3.setTitle("关于我们", for: .normal)
            cell.btn3.setImage(UIImage(named: "关于我们"), for: .normal)
            cell.btn4.setTitle("设置", for: .normal)
            cell.btn4.setImage(UIImage(named: "设置"), for: .normal)
            cell.name.text = "会员中心"
            cell.btn1.tag = indexPath.section*100 + 1
            cell.btn2.tag = indexPath.section*100 + 2
            cell.btn3.tag = indexPath.section*100 + 3
            cell.btn4.tag = indexPath.section*100 + 4
            cell.btn5.isHidden = true
            cell.btn1.addTarget(self, action: #selector(toolAction(btn:)), for: .touchUpInside)
            cell.btn2.addTarget(self, action: #selector(toolAction(btn:)), for: .touchUpInside)
            cell.btn3.addTarget(self, action: #selector(toolAction(btn:)), for: .touchUpInside)
            cell.btn4.addTarget(self, action: #selector(toolAction(btn:)), for: .touchUpInside)
            cell.btn5.isHidden = true
        }
        return cell
    }

    @objc func toAccount() {
        if UserSetting.default.activeUserToken?.isEmpty ?? true {
            let login = LoginViewController()
            login.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(login, animated: true)
            return
        }
        let account = AccountInfoViewController()
        account.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(account, animated: true)
    }

    @objc func runOrderVc(btn: UIButton) {
        if UserSetting.default.activeUserToken == nil {
        let login = LoginViewController()
            login.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(login, animated: true)
            return
        }
//        if btn.tag == 5 {
//            let eva = EvaluateManagerViewController()
//            eva.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(eva, animated: true)
//            return
//        }
        if btn.tag == 6 {
            let eva = BaclGoodsViewController()
            eva.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(eva, animated: true)
            return
        }
        let order = OrderViewController() 
        order.hidesBottomBarWhenPushed = true
        order.tab_status = "\(btn.tag)"
        self.navigationController?.pushViewController(order, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vi = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        vi.backgroundColor = UIColor.tableviewBackgroundColor
        return vi
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else if indexPath.section == 2 {
            return 122
        } else if indexPath.section == 3 {
            return 90
        } else if indexPath.section == 1 {
            return 120
        } else if indexPath.section == 5 {
            if code == "0" {
                return 147
            }
            return 226
        }
        return 147
    }

    @objc func tocheck() {
        let web = WebViewController()
        web.uri = "https://app.necesstore.com/html/luck.html?user_token=\(UserSetting.default.activeUserToken ?? "")"
        web.title = "签到抽奖"
        web.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(web, animated: true)
    }
}
