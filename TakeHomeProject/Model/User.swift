//
//  User.swift
//  TakeHomeProject
//
//  Created by ezz on 03/01/2025.
//

import Foundation
struct User : Codable {
    let login : String
    let avatar_url : String
    var name : String?
    var location : String?
    var bio : String?
    let public_repos : Int
    let public_gists : Int
    let html_url : String
    let followers : Int
    let following : Int
    let created_at : String
}
