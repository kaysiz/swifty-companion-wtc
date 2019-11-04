//
//  ViewController.swift
//  companion
//
//  Created by kudakwashe on 2019/10/09.
//  Copyright © 2019 WeThinkCode. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct tokenData {
    static var global = tokenData()
    let uid: String = "5c15d0164aa753e9b2903f57fc21fbe330fd34e51315bc34d632537f50d863ce"
    let secret: String = "9807057f913469dc20ac0f17354b98c93ce0b4227d80628ced241384cdf930e1"
    var token: String = ""
}

class ViewController: UIViewController {

    @IBOutlet weak var laError: UILabel!
    var isAvailable: Bool = true
    var username = ""
    
    @IBOutlet weak var Txtusername: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        get_token()
    }
    
    @IBAction func buSearch(_ sender: Any) {
        if isAvailable {
            username = Txtusername.text!
            performSegue(withIdentifier: "userProfile", sender: self)
        } else {
            laError.text = "*User not found!"
            Txtusername.text = ""
        }
    }
    
    func getUserProfile(){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! UserProfileViewController
        vc.finalName = self.username
    }
    
    func get_token() {
        
        let url = "https://api.intra.42.fr/oauth/token"
        let config = [
            "grant_type": "client_credentials",
            "client_id": tokenData.global.uid,
            "client_secret": tokenData.global.secret]
        let verify = UserDefaults.standard.object(forKey: "token")
        if verify == nil {
            Alamofire.request(url, method: .post, parameters: config).validate().responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if let token = json["access_token"].string {
                        tokenData.global.token = token
                        print(tokenData.global.token)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        else {
        }
    }
}

