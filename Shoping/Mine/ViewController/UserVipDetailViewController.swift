//
//  UserVipDetailViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/18.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import MJRefresh

class UserVipDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var page = 1
    var start = ""
    var end = ""
    var token = ""
    var date = "2020-04"
    var data: FansList? = nil
    @IBOutlet weak var bbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "会员详情"
        bbtn.layer.cornerRadius = 19
        bbtn.layer.masksToBounds = true
        start = dateConvertString(date: startOfCurrentMonth())
        end = dateConvertString(date: endOfCurrentMonth())
        tableView.register(UINib(nibName: "UserVipDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "UserVipDetailTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.tableviewBackgroundColor
        loadData()
//        tableView.separatorStyle = .none
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page = self.page + 1
            self.loadDataMore()
        })
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.loadData()
        })
    }

    func loadData() {
        API.fansListData(user_token: token, month: date, page: "\(page)").request { (result) in
            self.tableView.mj_header?.endRefreshing()
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }

    func loadDataMore() {
        API.fansListData(user_token: token, month: date, page: "\(page)").request { (result) in
            self.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let data):
                var ar = self.data?.data.orderList
                ar = (ar ?? []) + data.data.orderList
                self.data = FansList(result: true, message: "", status: 200, data: FansListDataClass(orderList: ar ?? []))
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }

    @IBAction func selectAction(_ sender: UIButton) {
       //年-月
//       WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonth CompleteBlock:^(NSDate *selectDate) {
//
//           NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM"];
//           NSLog(@"选择的日期：%@",dateString);
//           [btn setTitle:dateString forState:UIControlStateNormal];
//       }];
//       datepicker.dateLabelColor = randomColor;//年-月-日-时-分 颜色
//       datepicker.datePickerColor = randomColor;//滚轮日期颜色
//       datepicker.doneButtonColor = randomColor;//确定按钮的颜色
//       [datepicker show];
        let datepicker = WSDatePickerView(dateStyle: DateStyleShowYearMonth) { (dat) in
            self.date = self.dateConvertString(date: dat ?? Date.init())
            self.loadData()
            sender.setTitle(self.dateConvertString(date: dat ?? Date.init()), for: .normal)
        }
        datepicker?.show()
    }

    func startOfCurrentMonth() -> Date {
        let date = Date()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(
            Set<Calendar.Component>([.year, .month]), from: date)
        let startOfMonth = calendar.date(from: components)!
        return startOfMonth
    }

    func endOfCurrentMonth(returnEndTime:Bool = false) -> Date {
        let calendar = NSCalendar.current
        var components = DateComponents()
        components.month = 1
        if returnEndTime {
            components.second = -1
        } else {
            components.day = -1
        }

        let endOfMonth =  calendar.date(byAdding: components, to: startOfCurrentMonth())!
        return endOfMonth
    }

    func startOfCurrentYear() -> Int {
        let date = Date()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(
            Set<Calendar.Component>([.year, .month]), from: date)
        let startOfMonth = calendar.date(from: components)!
        return Int(dateConvertString(date: startOfMonth, dateFormat: "yyyy")) ?? 2020
    }

    func dateConvertString(date:Date, dateFormat:String="yyyy-MM") -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            let date = formatter.string(from: date)
            return date.components(separatedBy: " ").first!
        }

    func startOfMonth(year: Int, month: Int) -> Date {
        let calendar = NSCalendar.current
        var startComps = DateComponents()
        startComps.day = 1
        startComps.month = month
        startComps.year = year
        let startDate = calendar.date(from: startComps)!
        return startDate
    }

    //指定年月的结束日期
    func endOfMonth(year: Int, month: Int, returnEndTime:Bool = false) -> Date {
        let calendar = NSCalendar.current
        var components = DateComponents()
        components.month = 1
        if returnEndTime {
            components.second = -1
        } else {
            components.day = -1
        }

        let endOfYear = calendar.date(byAdding: components,
                                      to: startOfMonth(year: year, month:month))!
        return endOfYear
    }
}
extension UserVipDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.orderList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserVipDetailTableViewCell") as! UserVipDetailTableViewCell
        cell.selectionStyle = .none
        let item = data?.data.orderList[indexPath.row]
        cell.date.text = item?.created
        cell.price.text = "￥\(item?.price ?? "")"
        cell.point.text = item?.pointSave
        cell.redPackge.text = item?.redpackageSave
        cell.yongjin.text = item?.commissionSave
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
}
