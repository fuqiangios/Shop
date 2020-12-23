//
//  RedPackageRainViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/12/11.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit
import AudioToolbox

class RedPackageRainViewController: UIViewController {
    let redPackRain = RedpackRainView()
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var iconImage: UIImageView!

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var checkHistory: UIButton!
    @IBOutlet weak var resultName: UILabel!

    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var resultPopView: UIView!
    var closeRedPackRainAndJumpHistory: ((Int) -> Void)!
    var plan_luck_id: String?
    var isResult: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        closeBtn.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        checkHistory.addTarget(self, action: #selector(jumpToHistory), for: .touchUpInside)
        self.view.addSubview(redPackRain)
        redPackRain.frame = self.view.bounds
        resultPopView.layer.cornerRadius = 5
        resultPopView.layer.masksToBounds = true
        checkHistory.layer.cornerRadius = 20
        iconImage.layer.masksToBounds = true
//        iconImage.layer.borderWidth = 2
//        checkHistory.layer.borderColor = UIColor.init(white: 1, alpha: 0.1).cgColor
        iconImage.layer.cornerRadius = 35
        iconImage.layer.masksToBounds = true

        // 设置 轮播的红包图片, 和点击效果
        redPackRain.setRedPack(images:
            [UIImage.init(named: "hongbao")!],size: CGSize(width: 80, height: 80)) { (redPackView, clickview) in
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                guard let layer = clickview.layer.presentation() else {
                    return
                }
            let newRedPack = UIImageView()
            newRedPack.image = UIImage(named: "hongbao")
            newRedPack.bounds = clickview.bounds
            newRedPack.center = CGPoint(x: layer.frame.origin.x + layer.frame.width/2, y: layer.frame.origin.y + layer.frame.height/2)
            newRedPack.transform = layer.affineTransform()
            redPackView.addNotPenetrateViews(views: [newRedPack])
            redPackView.addSubview(newRedPack)
            newRedPack.boom()
            // 只显示0.3秒
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                newRedPack.removeFromSuperview()
            })

            print("累计\(redPackView.redPackClickedCount)个红包")
            clickview.removeFromSuperview()
            self.openPlanLuck()
        }

        // 设置红包结束回调
        redPackRain.setCompleteHandle { (redPackView) in
            print("一共点中了\(redPackView.redPackClickedCount)个红包")
            self.redPackRain.removeFromSuperview()
            if !self.isResult {
                self.openPlanLuck()
            }
//            if (redPackView.redPackClickedCount <= 0){
//                self.dismiss(animated: false, completion: nil)
//                self.closeRedPackRainAndJumpHistory(2)
//            }
        }
    }

    func openPlanLuck() {
        if isResult {
            return
        }
        isResult = true
        API.openPlanLuck(user_token: UserSetting.default.activeUserToken ?? "", plan_luck_id: plan_luck_id ?? "").request { (result) in
            switch result{
            case .success(let data):
                self.redPackRain.stopRain()
                self.redPackRain.removeFromSuperview()
                self.resultTitle.text = data.data.title
                self.resultName.text = data.data.win_msg
                self.resultView.isHidden = false
            case .failure(let er):
                print(er)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        redPackRain.startGame()
    }


    @objc func jumpToHistory() {

    }

    @IBAction func jumpTohistoryAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        closeRedPackRainAndJumpHistory(1)
    }
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        closeRedPackRainAndJumpHistory(2)
    }
    @objc func closeView() {
        self.dismiss(animated: false, completion: nil)

    }
}
