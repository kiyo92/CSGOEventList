//
//  MatchItemListModel.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 25/07/23.
//

import Foundation

struct MatchItemListModel: Codable {

    var opponents: [MatchOpponentListModel]?
    var begin_at: String?
    var league: MatchLeagueModel?
}

struct MatchLeagueModel: Codable {

    var image_url: String?
    var name: String?
    var imageData: Data?
}

struct MatchOpponentListModel: Codable {

    var opponent: MatchOpponentModel?
    var imageData: Data?
}

struct MatchOpponentModel: Codable {

    var image_url: String?
    var name: String?
    var id: Int?
}
