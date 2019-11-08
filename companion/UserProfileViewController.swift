//
//  UserProfileViewController.swift
//  companion
//
//  Created by kudakwashe on 2019/10/25.
//  Copyright © 2019 WeThinkCode. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var btnUserName: UILabel!
    
    var finalName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnUserName.text = user.email
        print(user.email as Any)

        // Do any additional setup after loading the view.
    }

}
