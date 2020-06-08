//
//  ViewController.swift
//  AVAlert
//
//  Created by Admin on 08/06/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func showAlert(sender: UIButton) {
        
        switch sender.tag {
        case 0:
            AVAlert.alert("Hello")
        default: break
           
        }
    }

}

