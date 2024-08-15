//
//  Server.swift
//  ConFlow
//
//  Created by Joseph Tham on 7/16/24.
//

import Foundation

struct Server: Codable {
    let id: String
    let name: String
    let code: String
    let members: [String]
}
