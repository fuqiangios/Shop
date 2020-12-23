//
//  ShipingInputViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/9/1.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class ShipingInputViewController: UIViewController {
    var backOnClickSubmit: ((String, String) -> Void)?
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var name: UITextField!
    var other: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        number.tag = 60
        name.tag = 61
        number.delegate = self
        name.delegate = self
        name.tag = 200
        number.setValue(UIColor.black, forKeyPath: "placeholderLabel.textColor")
        number.textColor = .black
        name.setValue(UIColor.black, forKeyPath: "placeholderLabel.textColor")
        name.textColor = .black
    }

    @IBAction func submit(_ sender: Any) {
        number.resignFirstResponder()
        name.resignFirstResponder()
        backOnClickSubmit?(name.text ?? "", number.text ?? "")
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
extension ShipingInputViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 200, !other {
            textField.resignFirstResponder()
            selectShiping()
        }
    }

    func selectShiping() {
        let alertController = UIAlertController(title: "选择物流", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel) { (btn) in
            print("点击了取消")
        }
        let ar = ["申通","中通","韵达","圆通","其他"]
        alertController.addAction(cancelAction)
        for item in ar {
            let action = UIAlertAction(title: item, style: UIAlertAction.Style.default) { (btn) in
                if btn.title == "其他" {
                    self.other = true
                    self.name.becomeFirstResponder()
                } else {
                    self.name.text = btn.title
                }
            }
            alertController.addAction(action)
        }

        self.present(alertController, animated: true, completion: nil)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        other = false
    }
}
