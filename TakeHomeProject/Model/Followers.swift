//
//  Followers.swift
//  TakeHomeProject
//
//  Created by ezz on 03/01/2025.
//

import Foundation
struct Follower : Codable , Hashable {
    var login : String
    var avatar_url : String
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(login)
//    }
//
//    static func == (lhs: Follower, rhs: Follower) -> Bool {
//        return lhs.login == rhs.login
//    }
}
