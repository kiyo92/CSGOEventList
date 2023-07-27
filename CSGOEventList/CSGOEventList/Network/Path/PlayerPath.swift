//
//  PlayerPath.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 27/07/23.
//

import Foundation

class PlayerPath: PathProtocol {

    enum Path {

        case matchDetails
    }

    let path: Path

    init(path: Path) {

        self.path = path
    }

    func getPath() -> String {

        switch path {

        case .matchDetails:

            return "/csgo/players"
        }
    }
}
