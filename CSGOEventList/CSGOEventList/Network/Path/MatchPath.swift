//
//  MatchPath.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 25/07/23.
//

import Foundation

class MatchPath: PathProtocol {

    enum Path {

        case matchUpcomingList
        case matchRunningList
    }

    let path: Path

    init(path: Path) {

        self.path = path
    }

    func getPath() -> String {

        switch path {

        case .matchUpcomingList:

            return "/csgo/matches/upcoming"
        case .matchRunningList:

            return "/csgo/matches/running"
        }
    }
}
