//
//  ViewController.swift
//  companion
//
//  Created by kudakwashe on 2019/10/09.
//  Copyright © 2019 WeThinkCode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var laError: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buSearch(_ sender: Any) {
        laError.text = "*User not found!"
    }
}

