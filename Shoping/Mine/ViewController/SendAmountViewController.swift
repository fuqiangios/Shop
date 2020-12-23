//
//  SendAmountViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/8/16.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class SendAmountViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var amountInput: UITextField!

    @IBOutlet weak var canAmount: UILabel!
    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var message: UITextField!
    @IBOutlet weak var getAll: UIButton!
    @IBOutlet weak var amount: UILabel!
    var amountI = "0.00"
    var am = "0.00"
    var messageI = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "余额转赠"
        send.layer.cornerRadius = 5
        send.layer.masksToBounds = true
        amountInput.delegate = self
        amountInput.tag = 100

        message.delegate = self
        message.tag = 101

        amountInput.text = "0.00"
        canAmount.text = amountI
        getAll.addTarget(self, action: #selector(getAllAcount), for: .touchUpInside)
        send.addTarget(self, action: #selector(sendAm), for: .touchUpInside)
    }

    @objc func getAllAcount() {
        am = amountI
        amountInput.text = am
    }

    @objc func sendAm() {
        let popUp = PayPasswordPopupViewController()
        popUp.modalPresentationStyle = .custom
        popUp.didCofirmPassword = { code in
            self.api(code: code)
        }
        popUp.didToSet = {
            if UserSetting.default.activeUserPhone != nil {
                                let payPassword = PayPasswordViewController()
                self.navigationController?.pushViewController(payPassword, animated: true)
            } else {
                let payPassword = MailPayPasswordViewController()
                self.navigationController?.pushViewController(payPassword, animated: true)
            }
        }
        self.present(popUp, animated: false, completion: nil)
    }

    @objc func api(code: String) {
        API.sendAmount(amount: am, to_user: messageI, pay_password: code).request { (result) in
            switch result {
            case .success(let data):
                CLProgressHUD.showError(in: self.view, delegate: self, title: data.message, duration: 1)
                if data.status == 200 {
                    self.navigationController?.popViewController(animated: true)
                }

            case .failure(let er):
                print(er)
            }
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 100 {
            am = textField.text ?? ""
            
        } else {
            messageI = textField.text ?? ""
        }
    }

}
