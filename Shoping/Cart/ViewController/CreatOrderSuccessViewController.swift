//
//  CreatOrderSuccessViewController.swift
//  Shoping
//
//  Created by qiang.c.fu on 2020/4/23.
//  Copyright © 2020 付强. All rights reserved.
//

import UIKit

class CreatOrderSuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
