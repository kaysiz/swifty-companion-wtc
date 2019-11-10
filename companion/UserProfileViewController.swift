//
//  UserProfileViewController.swift
//  companion
//
//  Created by kudakwashe on 2019/10/25.
//  Copyright © 2019 WeThinkCode. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage
import DDSpiderChart

class UserProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 400)
        
        view.addSubview(skillsView)
        skillsView.anchor(top: containerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20)
        skillsView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.addSubview(tableView)
        tableView.anchor(top: containerView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlue
        
        // profile picture
        view.addSubview(profileImageView)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.anchor(top: view.topAnchor, paddingTop: 100, width: 150, height: 150)
        
        // pool month label
        view.addSubview(poolMonthLabel)
        poolMonthLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop:90, paddingLeft: 32)
        
        // pool year label
        view.addSubview(poolYearLabel)
        poolYearLabel.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 90, paddingRight: 32)
        
        // login name label
        view.addSubview(loginLabel)
        loginLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 12)
        loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // email label
        view.addSubview(emailLabel)
        emailLabel.anchor(top: loginLabel.bottomAnchor, paddingTop: 12)
        emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // level label
        view.addSubview(levelLabel)
        levelLabel.anchor(top: emailLabel.bottomAnchor, paddingTop: 12)
        levelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        return view
    }()

    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 150 / 2
        return iv
    }()
    
    let levelLabel: UILabel = {
        let lv = UILabel()
        lv.textAlignment = .center
        lv.font = UIFont.boldSystemFont(ofSize: 18)
        lv.textColor = .white
        return lv
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .white
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    let poolMonthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    let poolYearLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    let skillsView: DDSpiderChartView = {
        let spiderChartView = DDSpiderChartView() // Replace with some frame or add constraints
        return spiderChartView
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .red
        return table
    }()
    
    // MARK: - Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = user.displayName
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor )
        
        if (user.image_url != nil) {
            Alamofire.request(user.image_url!).responseImage(completionHandler: { response in

                if let image = response.result.value {
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                        self.loginLabel.text = user.login
                        self.emailLabel.text = user.email
                        self.poolMonthLabel.text = user.pool_month?.capitalized
                        self.poolYearLabel.text = user.pool_year
                        
                        var lev = user.level! - Double(Int(user.level!))
                        lev = lev * 100
                        lev = round(lev)
                        let levell = Int(lev)
                        self.levelLabel.text = "Level " + String(Int(user.level!)) + " - " + String(levell) + "%"
                        
                        self.student_skils()
                    }
                }
            })
        } else {
            print("no picture in url")
            DispatchQueue.main.async {
                self.loginLabel.text = user.login
                self.emailLabel.text = user.email
                self.poolMonthLabel.text = user.pool_month
                self.poolYearLabel.text = user.pool_year
                self.student_skils()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func student_skils() {
        
        user.skills = user.skills.sorted(by: { $0 > $1 })
        skillsView.color = .gray
        var val : [Float] = []
        var name : [String] = []
        
        for i in 0..<user.skills.count {
            
            name.append(user.skills[i].0)
            val.append(user.skills[i].1 / 20.0)
        }
        skillsView.axes = name.map { attributedAxisLabel($0) }
        skillsView.addDataSet(values:val, color: UIColor(red: 0.1, green: 0.7, blue: 0.6, alpha: 1.0))
        skillsView.backgroundColor = .clear
        skillsView.circleCount = 4
        skillsView.circleGap = 20
    }
    
    func attributedAxisLabel(_ label: String) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: label, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "ArialMT", size: 8)!, NSAttributedString.Key.paragraphStyle: style]))
        return attributedString
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat)-> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let mainBlue = UIColor.rgb(red: 0, green: 150, blue: 255)
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat? = 0, paddingLeft: CGFloat? = 0, paddingBottom: CGFloat? = 0, paddingRight: CGFloat? = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
        }
        
        if let bottom = bottom {
            if let paddingBottom = paddingBottom {
                bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
        }
        
        if let right = right {
            if let paddingRight = paddingRight {
                rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            }
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
