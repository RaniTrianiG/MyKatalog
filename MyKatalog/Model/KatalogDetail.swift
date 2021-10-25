//
//  KatalogDetail.swift
//  MyKatalog
//
//  Created by Rani Triani Gustia on 22/10/21.
//

import SwiftUI

struct KatalogDetail: Decodable {
    var id: Int
    var name: String
    var background_image    : String
    var released: String
    var rating: Double
}
