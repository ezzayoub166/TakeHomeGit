//
//  GFError.swift
//  TakeHomeProject
//
//  Created by ezz on 09/01/2025.
//

import Foundation
enum GFError : String , Error {
    case invalidUsername  = "This username created as invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Plase Check your internt connection."
    case invalidResponse  = "Invalid response for server ,Please Try agian."
    case invalidData      = "The data received from server was invalid .please try again"
}
