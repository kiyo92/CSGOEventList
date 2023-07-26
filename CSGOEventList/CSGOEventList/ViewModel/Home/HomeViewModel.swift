//
//  HomeViewModel.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 25/07/23.
//

import Foundation

class HomeViewModel {

    private(set) var matchList: [MatchItemListModel] = []
    private let group = DispatchGroup()

    func getUpcomingMatches(completion: @escaping((Bool) -> Void)) async {

        let headers = [
            "accept": "application/json",
            "authorization": "Bearer ugzoCpm6qrNKV-unM3868dLR_ukHaRcxRFpnrpkdO9uPaQTkSpQ"
        ]

        let routeModel = RouteModel(path: MatchPath(path: .matchUpcomingList),
                                    headers: headers,
                                    queryParameters: [URLQueryItem(name: "page", value: "1")])

        let network = NetworkAdapter(routeModel: routeModel)

        await network.request(with: [MatchItemListModel].self) { [weak self] response, error in

            guard let self = self else { return }

            self.matchList.append(contentsOf: response ?? [])

            self.matchList.enumerated().forEach { (matchIndex, match) in
                self.group.enter()
                match.opponents?.enumerated().forEach { (opponentIndex, opponent) in
                    self.fetchImage(with: opponent.opponent?.image_url ?? "") { data, error in

                        self.matchList[matchIndex].opponents?[opponentIndex].imageData = data
                    }
                }

                self.fetchImage(with: match.league?.image_url ?? "") { data, error in

                    self.matchList[matchIndex].league?.imageData = data
                }

                self.group.leave()
            }

            group.notify(queue: .main) {

                completion(true)
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
