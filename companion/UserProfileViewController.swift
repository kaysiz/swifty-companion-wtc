//
//  UserProfileViewController.swift
//  companion
//
//  Created by kudakwashe on 2019/10/25.
//  Copyright © 2019 WeThinkCode. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var lTableView: UITableView!
    let cellId = "cellId1234"
    
    @IBOutlet weak var lImage: UIImageView!
    @IBOutlet weak var lLogin: UILabel!
    @IBOutlet weak var lLocation: UILabel!
    @IBOutlet weak var lEmail: UILabel!
    @IBOutlet weak var lLevel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = user.displayName
        navigationController?.navigationBar.prefersLargeTitles = true
        
        lTableView.register(UITableView.self, forCellReuseIdentifier: cellId)
    
        
        if (user.image_url != nil) {
            Alamofire.request(user.image_url!).responseImage(completionHandler: { response in
                
                if let image = response.result.value {
                    DispatchQueue.main.async {
                        self.lImage.image = image
                        self.lImage.layer.cornerRadius = self.lImage.frame.size.height / 4
                    }
                }
                
                DispatchQueue.main.async {
                    self.lLogin.text = user.login
                    self.lEmail.text = user.email
                    self.lLocation.text = user.pool_year
                }
                
            })
        } else {
            print("no picture in url")
            DispatchQueue.main.async {
                self.lLogin.text = user.login
                self.lEmail.text = user.email
                self.lLocation.text = user.pool_year
            }
        }
        // Do any additional setup after loading the view.
    }
}
