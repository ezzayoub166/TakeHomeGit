//
//  User.swift
//  TakeHomeProject
//
//  Created by ezz on 03/01/2025.
//

import Foundation
struct User : Codable {
    var login : String
    var avatar_url : String
    var name : String?
    var location : String?
    var bio : String?
    var public_repos : Int
    var public_gists : Int
    var html_url : String
    var followers : Int
    var following : Int
    var created_at : String
}
