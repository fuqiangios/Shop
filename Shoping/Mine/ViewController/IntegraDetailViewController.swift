//
//  IntegraDetailViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/16.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import MJRefresh

class IntegraDetailViewController: UIViewController {
    var data: PointList? = nil
    var page = 1
    var start = ""
    @IBOutlet weak var table: UITableView!
    var end = ""
    var type = "1"
    
    @IBOutlet weak var bbtn: UIButton!
    @IBOutlet weak var income: UILabel!
    @IBOutlet weak var pay: UILabel!
    
    @IBOutlet weak var incomeBtn: UIButton!
    @IBOutlet weak var payBtn: UIButton!
    
    @IBOutlet weak var linne: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        start = dateConvertString(date: startOfCurrentMonth())
        end = dateConvertString(date: endOfCurrentMonth())
        bbtn.layer.cornerRadius = 19
        bbtn.layer.masksToBounds = true
        title = "积分明细"
        table.register(UINib(nibName: "IntegraDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "IntegraDetailTableViewCell")


        table.estimatedRowHeight = 150
        table.rowHeight = UITableView.automaticDimension
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = UIColor.tableviewBackgroundColor
        table.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.page = self.page + 1
            self.loadDataMore()
        })
        table.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.loadData()
        })
        loadData()
    }

    func loadData() {
        API.pointInfoList(start_date: start, end_date: end, page: "\(page)", type: type).request { (result) in
            self.table.mj_header?.endRefreshing()
            switch result {
            case .success(let data):
                self.data = data
                self.pay.text = "支出：-\(data.data.pay)"
                self.income.text = "收入：+\(data.data.income)"
                self.table.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }

    func loadDataMore() {
        API.pointInfoList(start_date: start, end_date: end, page: "\(page)", type: type).request { (result) in
            self.table.mj_footer?.endRefreshing()
            switch result {
            case .success(let data):
                var ar = self.data?.data.pointsList
                ar = (ar ?? []) + data.data.pointsList
                self.data = PointList(result: data.result, message: data.message, status: data.status, data: PointListDataClass(pointsList: ar ?? [], income: data.data.income, pay: data.data.pay))
                self.pay.text = "支出：-\(data.data.pay)"
                self.income.text = "收入：+\(data.data.income)"
                self.table.reloadData()
            case .failure(let er):
                print(er)
            }
        }
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

    @IBAction func selectDate(_ sender: UIButton) {

        let datepicker = WSDatePickerView(dateStyle: DateStyleShowYearMonth) { (dat) in
//            self.date = self.dateConvertString(date: dat ?? Date.init())
            self.start = self.dateConvertString(date: dat ?? Date.init())
            self.end = self.dateConvertString(date: dat ?? Date.init())
            self.loadData()
            sender.setTitle(self.dateConvertString(date: dat ?? Date.init()), for: .normal)
        }
        datepicker?.show()
    }
    func dateConvertString(date:Date, dateFormat:String="yyyy-MM") -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            let date = formatter.string(from: date)
            return date
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

    @IBAction func payAction(_ sender: UIButton) {
        type = "1"
        page = 1
        loadData()
        linne.center = CGPoint(x: sender.center.x, y: sender.center.y + 24)
    }
    
    @IBAction func incomeAction(_ sender: UIButton) {
        type = "2"
        page = 1
        loadData()
        linne.center = CGPoint(x: sender.center.x, y: sender.center.y + 24)
    }
}
extension IntegraDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.pointsList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IntegraDetailTableViewCell") as! IntegraDetailTableViewCell
        cell.selectionStyle = .none
        let item = data?.data.pointsList[indexPath.row]
        cell.name.text = item?.method ?? ""
        cell.date.text = item?.created ?? ""
        cell.point.text = item?.value ?? ""
        if item?.incomeFlag ?? false {
            cell.point.textColor = .red
        } else {
            cell.point.textColor = cell.name.textColor
        }
        return cell
    }


}
