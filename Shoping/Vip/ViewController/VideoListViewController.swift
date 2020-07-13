//
//  VideoListViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/6/29.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var data: VideoList? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "VideoListTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoListTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
                tableView.backgroundColor = UIColor.tableviewBackgroundColor
        tableView.separatorStyle = .none
        loadData()
    }

    func loadData() {
        API.getVideoList().request { (result) in
            switch result {
            case .success(let data):
                self.data = data
                self.tableView.reloadData()
            case .failure(let er):
                print(er)
            }
        }
    }
}

extension VideoListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return data?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vg = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 10))
        vg.backgroundColor = .groupTableViewBackground
        return vg
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListTableViewCell") as! VideoListTableViewCell
        cell.selectionStyle = .none
        let item = data?.data[indexPath.section]
        cell.img.af_setImage(withURL: URL(string: item!.cover)!)
        cell.name.text = item?.title
        cell.date.text = item?.releaseTime
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: urlEncode(str: data?.data[indexPath.section].url ?? "https://app.necesstore.com/upload/video/091138340.png")) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated:true, completion: nil)
        }
    }

    func urlEncode(str: String) -> String {
        return str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://app.necesstore.com/upload/video/091138340.png"

    }
}
