//
//  UserVipDetailViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/18.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class UserVipDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var page = 1
    var start = ""
    var end = ""
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
//        tableView.separatorStyle = .none
    }

    @IBAction func selectAction(_ sender: Any) {
        let dat = [1,2,3,4,5,6,7,8,9,10,11,12]
        let alertController = UIAlertController(title: "申请原因", message: "", preferredStyle: UIAlertController.Style.actionSheet)

        for item in dat {
            alertController.addAction(UIAlertAction(title: "\(item)月", style: UIAlertAction.Style.default, handler:{ (l) in
                self.start = self.dateConvertString(date: self.startOfMonth(year: self.startOfCurrentYear(), month: item))
                self.end = self.dateConvertString(date: self.endOfMonth(year: self.startOfCurrentYear(), month: item))
//                self.loadData()
                }))
        }
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(alertController, animated: true, completion: nil)
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

    func dateConvertString(date:Date, dateFormat:String="yyyy-MM-dd") -> String {
            let timeZone = TimeZone.init(identifier: "UTC")
            let formatter = DateFormatter()
            formatter.timeZone = timeZone
            formatter.locale = Locale.init(identifier: "zh_CN")
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
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserVipDetailTableViewCell") as! UserVipDetailTableViewCell
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
}
