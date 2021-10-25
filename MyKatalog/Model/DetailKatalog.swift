//
//  DetailKatalog.swift
//  MyKatalog
//
//  Created by Rani Triani Gustia on 22/10/21.
//

import SwiftUI

struct ResponseDetail: Decodable {
    var id: Int
    var name: String
    var description: String
    var released : String
    var rating: Double
}

struct DetailKatalog: Decodable {
    var id: Int
    var name: String
    var description: String
    var released: String
    var rating: Double
}
