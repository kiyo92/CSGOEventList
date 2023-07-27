//
//  PlayerDetailModel.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 27/07/23.
//

import Foundation

struct PlayerDetailModel: Codable {

    var firstName: String?
    var lastName: String?
    var imageUrl: String?
    var name: String?
    var imageData: Data?

    enum CodingKeys: String, CodingKey {

        case firstName = "first_name"
        case lastName = "last_name"
        case imageUrl = "image_url"
        case name
        case imageData
    }
}
