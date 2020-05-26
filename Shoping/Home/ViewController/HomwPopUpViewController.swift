//
//  HomwPopUpViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/5/21.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class HomwPopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func diss(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        API.getRed(type: "").request { (_) in

        }
    }

}
