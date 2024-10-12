//
//  AllergiesModel.swift
//  PersonalizeApp
//
//  Created by Pyae Phyo Oo on 12/10/2024.
//

import Foundation

struct AllergiesModel: Codable {
    let data: [AllergiesModelData]
}

struct AllergiesModelData: Codable {
    let id: Int
    let name: String
}
