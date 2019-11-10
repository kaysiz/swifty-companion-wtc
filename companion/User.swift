//
//  User.swift
//  companion
//
//  Created by kudakwashe on 2019/10/25.
//  Copyright © 2019 WeThinkCode. All rights reserved.
//

import Foundation

struct user {
    static var id: String?;
    static var login: String?;
    static var correction_point: String?;
    static var email: String?;
    static var image_url: String?;
    static var location: String?;
    static var level: Double?;
    static var pool_month: String?;
    static var pool_year: String?;
    static var campus: String?;
    static var displayName: String?;
    
    static var skills: [(String, Float)] = [(String, Float)]()
}
