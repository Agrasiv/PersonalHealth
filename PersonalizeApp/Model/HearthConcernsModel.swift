//
//  HearthConcernsModel.swift
//  PersonalizeApp
//
//  Created by Pyae Phyo Oo on 12/10/2024.
//

import Foundation

struct HearthConcernsModel: Codable {
    let data: [HearthConcernsModelData]
}

struct HearthConcernsModelData: Codable {
    let id: Int
    let name: String
    var isSelected: Bool?
}
