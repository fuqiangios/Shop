//
//  SettingViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/18.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import AlamofireImage

class SettingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var size = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "设置"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        tableView.register(UINib(nibName: "LogOutTableViewCell", bundle: nil), forCellReuseIdentifier: "LogOutTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.backgroundColor = UIColor.tableviewBackgroundColor
        tableView.separatorStyle = .none
        getCache()
    }

    func getCache() {
        floderSizeAtPath { (size) in
            self.size = Double(size)
            self.tableView.reloadData()
        }
    }
}
extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogOutTableViewCell") as! LogOutTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell") as! SettingTableViewCell
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.title.text = "消息推送"
            cell.info.text = "去设置"
        } else if indexPath.row == 1 {
            cell.title.text = "清楚缓存"
            cell.info.text =  String(format: "%.2fM", size)
        } else {
            cell.title.text = "关于我家用品"
            cell.info.text = ""
        }
        if indexPath.row == 1 {
            cell.imgWidth.constant = 0
            cell.img.isHidden = true
            cell.infoRight.constant = 0
        } else {
            cell.imgWidth.constant = 16
            cell.img.isHidden = false
            cell.infoRight.constant = 4
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let urlObj = URL(string:UIApplication.openSettingsURLString)
             if #available(iOS 10.0, *) {
                   UIApplication.shared.open(urlObj! as URL, options: [ : ], completionHandler: { Success in

            })} else {
                   UIApplication.shared.openURL(urlObj!)
             }
        } else if indexPath.row == 1 {
            clearCache {
                self.getCache()
            }
        } else if indexPath.row == 2 {
            let web = WebViewController()
            web.uri = "https://app.necesstore.com/html/about.html"
            web.title = "关于我们"
            web.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(web, animated: true)
        } else if indexPath.row == 3 {
            UserSetting.default.activeUserToken = nil
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    func  floderSizeAtPath(completion:@escaping (( _ fileSize:CGFloat)->Void)){
        DispatchQueue.global().async {
            var fileSize = CGFloat(0)
            if let floderPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first {
                let fineManager = FileManager.default
                if fineManager.isExecutableFile(atPath: floderPath) {
                    if let child = fineManager.subpaths(atPath: floderPath) {
                        var size = CGFloat(0)
                        for path in child {
                            let subStr = "\(floderPath)/\(path)"
                            let aSize =  self.fileSizeAtPath(filePath: subStr)
                            size = size + aSize
                        }
                        let allSize = size/(1024 * 1024)
                        fileSize = allSize
                    }else{
                        fileSize = CGFloat(0)
                    }
                }else {
                    fileSize = CGFloat(0)
                }
            }else{
                fileSize = CGFloat(0)
            }
            DispatchQueue.main.async {
                completion(fileSize)
            }
        }
    }
    func fileSizeAtPath(filePath:String) -> CGFloat{
        let manager = FileManager.default
        if manager.isExecutableFile(atPath: filePath) {
            return CGFloat(0)
        }
        if let dic:[FileAttributeKey : Any] = try? manager.attributesOfItem(atPath: filePath) as  [FileAttributeKey : Any] {
            if let size =  dic[FileAttributeKey.size] as? Double {
                return CGFloat(size)
            }
        }
        return CGFloat(0)
    }
    func clearCache(completion:@escaping (()->Void)){
        DispatchQueue.global().async {
            if let floderPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first {
                let fineManager = FileManager.default
                if fineManager.isExecutableFile(atPath: floderPath) {
                    if  let subpaths  =  try?fineManager.contentsOfDirectory(atPath:floderPath) {
                        for subPath in subpaths {
                            let filePath = "\(floderPath)/\(subPath)"
                            try?fineManager.removeItem(atPath: filePath)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
        let storage = HTTPCookieStorage.shared
        if let cookies =  storage.cookies {
            for cookie  in cookies {
                storage.deleteCookie(cookie)
            }
        }
        let urlCache = URLCache.shared
        urlCache.removeAllCachedResponses()
        urlCache.diskCapacity = 0
        urlCache.memoryCapacity  = 0
    }
}
