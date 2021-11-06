//
//  Result.swift
//  MyKatalog
//
//  Created by Rani Triani Gustia on 22/10/21.
//

import Foundation

struct Response: Codable {
    var results: [Result]
}

struct Result: Identifiable, Codable {
    var id: Int
    var name: String
    var background_image: String
    var released: String
    var rating: Double
}
