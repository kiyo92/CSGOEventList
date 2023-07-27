//
//  MatchViewModel.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 27/07/23.
//

import Foundation

class MatchViewModel {

    func getTeamData(teamID: String, completion: @escaping([PlayerDetailModel]) -> Void) async {

        let headers = [
            "accept": "application/json",
            "authorization": "Bearer ugzoCpm6qrNKV-unM3868dLR_ukHaRcxRFpnrpkdO9uPaQTkSpQ"
        ]

        let routeModel = RouteModel(path: PlayerPath(path: .matchDetails),
                                    headers: headers,
                                    queryParameters: [URLQueryItem(name: "filter[team_id]", value: "\(teamID)")])

        let network = NetworkAdapter(routeModel: routeModel)

        await network.request(with: [PlayerDetailModel].self) { response, error in

            completion(response ?? [])
        }
    }
}
