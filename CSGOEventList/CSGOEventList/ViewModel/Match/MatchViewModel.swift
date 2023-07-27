//
//  MatchViewModel.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 27/07/23.
//

import Foundation

class MatchViewModel {

    func getTeamData(teamID: String, completion: @escaping([PlayerDetailModel]) -> Void) async {

        var playerList: [PlayerDetailModel] = []

        var group = DispatchGroup()

        let headers = [
            "accept": Constants.accept,
            "authorization": Constants.token
        ]

        let routeModel = RouteModel(path: PlayerPath(path: .matchDetails),
                                    headers: headers,
                                    queryParameters: [URLQueryItem(name: "filter[team_id]", value: "\(teamID)")])

        let network = NetworkAdapter(routeModel: routeModel)

        await network.request(with: [PlayerDetailModel].self) { [weak self] response, error in

            guard let self = self else { return }

            playerList.append(contentsOf: response ?? [])

            for (index, player) in playerList.enumerated() {

                group.enter()
                if let imageUrl = player.imageUrl {

                    self.fetchImage(with: imageUrl) { data, error in

                        playerList[index].imageData = data
                        group.leave()
                    }
                } else {

                    group.leave()
                }
            }

            group.notify(queue: .main) {

                completion(playerList)
            }
        }
    }

    private func fetchImage(with url: String, completion: @escaping(Data, Error?) -> Void) {

        let routeModel = RouteModel(path: CustomPath(absolutePath: url))
        let network = NetworkAdapter(routeModel: routeModel)

        network.request() { data, response, error in

            completion(data ?? Data(), error)
        }
    }
}
