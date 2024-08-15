//
//  User.swift
//  ConFlow
//
//  Created by Joseph Tham on 7/14/24.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval
}
