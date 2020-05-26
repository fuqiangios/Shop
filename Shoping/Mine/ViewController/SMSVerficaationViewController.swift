//
//  SMSVerficaationViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/5/24.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class SMSVerficaationViewController: UIViewController {

    @IBOutlet weak var subbmit: UIButton!
    @IBOutlet weak var getCode: UIButton!
    @IBOutlet weak var input: UITextField!

    var type = "1"
    override func viewDidLoad() {
        super.viewDidLoad()
        subbmit.layer.cornerRadius = 5
        subbmit.layer.masksToBounds = true
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func getCodeAction(_ sender: UIButton) {
        let phoneStr = UserSetting.default.activeUserPhone ?? ""
        if phoneStr.count == 11 {
                API.getCode(telephone: phoneStr).request { (result) in
                    switch result {
                    case .success:
                        print("success")
                        self.timeChange(btn: sender)
                    case .failure(let error):
                        CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "发送失败，请重试", duration: 1)
                        print(error)
                        print(error.self)
                        print(error.localizedDescription)
                    }
                }
            }
        }

        func timeChange(btn: UIButton) {

                var time = 120
                let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
                codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))  //此处方法与Swift 3.0 不同
                codeTimer.setEventHandler {

                    time = time - 1

                    DispatchQueue.main.async {
                        btn.isEnabled = false
                    }

                    if time < 0 {
                        codeTimer.cancel()
                        DispatchQueue.main.async {
                            btn.isEnabled = true
                            btn.setTitle("重新发送", for: .normal)
                        }
                        return
                    }

                    DispatchQueue.main.async {
                        btn.setTitle("\(time)秒", for: .normal)
                    }

                }

                codeTimer.activate()

        }
    @IBAction func submitAction(_ sender: Any) {
        if input.text?.count == 4 {
            API.unBindWechat(telephone: UserSetting.default.activeUserPhone ?? "", code: input.text ?? "", type: type).request { (result) in
                switch result {
                case .success(let data):
                    CLProgressHUD.showSuccess(in: self.view, delegate: self, title: data.message, duration: 1)
                self.dismiss(animated: false, completion: nil)
                case .failure(let er):
                    CLProgressHUD.showSuccess(in: self.view, delegate: self, title: "解绑失败", duration: 1)
                    print(er)
                }
            }

        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
