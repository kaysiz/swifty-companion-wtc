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
//        get_token()
    }
    
    @IBAction func buSearch(_ sender: Any) {
        if isAvailable {
            username = Txtusername.text!
            get_data(login: username)
        } else {
            laError.text = "*User not found!"
            Txtusername.text = ""
        }
    }
    
    func getUserProfile(){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _ = segue.destination as! UserProfileViewController
    }
    
    func get_token() {
        
        let url = "https://api.intra.42.fr/oauth/token"
        let config = [
            "grant_type": "client_credentials",
            "client_id": tokenData.global.uid,
            "client_secret": tokenData.global.secret]
        Alamofire.request(url, method: .post, parameters: config).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let token = json["access_token"].string {
                    tokenData.global.token = token
                    UserDefaults.standard.set(token, forKey: "token")
                    print(tokenData.global.token)
                }
            case .failure(let error):
                print("getting token")
                print(error)
            }
        }
    }
    
    func get_data(login: String) {
        
        print(login)
        guard let userUrl = URL(string: "https://api.intra.42.fr/v2/users/" + login) else { return }
        if tokenData.global.token == "" {
            get_token()
        }
        let bearer = "Bearer " + tokenData.global.token
        var request = URLRequest(url: userUrl)
        request.httpMethod = "GET"
        request.setValue(bearer, forHTTPHeaderField: "Authorization")
        Alamofire.request(request as URLRequestConvertible).validate(statusCode: 200..<500).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                switch response.response?.statusCode {
                case 200, 201:
                    user.email = ""
                    if let email = json["email"].string {
                        user.email = email
                        print(email)
                    }
                    user.image_url = ""
                    if let image_url = json["image_url"].string {
                        user.image_url = image_url
                        print(image_url)
                    }
                    if let level = json["cursus_users"][0]["level"].double {
                        user.level = level
                    }
                    if let login = json["login"].string {
                        user.login = login
                        print(login)
                    }
                    if let pool_year = json["pool_year"].string {
                        user.pool_year = pool_year
                        print(pool_year)
                    }
                    if let displayName = json["displayname"].string {
                        user.displayName = displayName
                    }
                    if let pool_month = json["pool_month"].string {
                        user.pool_month = pool_month
                        print(pool_month)
                    }
                    //                user.correction_point = 0
                    //                if let correction_point = json["correction_point"].int {
                    //                    user.correction_point = correction_point
                    //                    print(correction_point)
                    //                }
                    //
                    //                if let campus_country = json["campus"][0]["country"].string {
                    //                    user.campus_country = campus_country
                    //                    print(campus_country)
                    //                }
                    //                if let campus_cite = json["campus"][0]["city"].string {
                    //                    user.campus_city = campus_cite
                    //                    print(campus_cite)
                    //                }
                    user.skills.removeAll()
                    if let skills = json["cursus_users"][0]["skills"].array {
                        for i in skills {
                            if let level = i["level"].float {
                                user.skills.append((i["name"].string!, level))
                            }
                        }
                    }
                    //                user.projects_users_sacces.removeAll()
                    //                user.projects_users_loading.removeAll()
                    //                user.projects_users_fail.removeAll()
                    //                if let projects_users = json["projects_users"].array {
                    //                    for i in projects_users {
                    //
                    //                        if i["final_mark"].int == nil {
                    //                            user.projects_users_loading.append((i["project"]["name"].string!, i["project"]["slug"].string!, i["status"].string!, i["validated?"].bool, 0)) }
                    //                        else {
                    //                            if i["validated?"].bool! == true && i["final_mark"].int != nil && i["final_mark"].int! > 0 {
                    //                                user.projects_users_sacces.append((i["project"]["name"].string!, i["project"]["slug"].string!, i["status"].string!, i["validated?"].bool, i["final_mark"].int)) }
                    //                            else if i["validated?"].bool! != true {
                    //                                user.projects_users_fail.append((i["project"]["name"].string!, i["project"]["slug"].string!, i["status"].string!, i["validated?"].bool, i["final_mark"].int)) }
                    //                        }
                    //                    }
                    self.performSegue(withIdentifier: "userProfile", sender: self)
                case 401:
                    print("Token Expired...retrying..... ")
                    self.get_token();
                    self.get_data(login: login)
                    break
                case 404:
                    print("what the fuck")
                    self.laError.text = "*User not found!"
                    self.Txtusername.text = ""
                    break
                default:
                    break
                }
            case .failure(let error):
                print(error)
                print("Something went extremely wrong")
            }
        }
    }

}

