//
//  HomeViewModel.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 25/07/23.
//

import Foundation

class HomeViewModel {

    enum MatchStatus {

        case upcoming
        case running
    }

    private(set) var matchList: [MatchItemListModel] = []
    private let group = DispatchGroup()
    private var currentPage = 1
    private var reachedLimit = false

    func getMatches(matchStatus: MatchStatus, isReload: Bool = false, completion: @escaping((Bool) -> Void)) async {

        if isReload {
            currentPage = 1
            reachedLimit = false
            matchList = []
        }

        let headers = [
            "accept": Constants.accept,
            "authorization": Constants.token
        ]

        let routeModel: RouteModel

        switch matchStatus {

        case .running:

            routeModel = RouteModel(path: MatchPath(path: .matchRunningList),
                                    headers: headers)
        case .upcoming:

            if reachedLimit {

                return
            }
            routeModel = RouteModel(path: MatchPath(path: .matchUpcomingList),
                                    headers: headers,
                                    queryParameters: [URLQueryItem(name: "page", value: "\(currentPage)")])
        }

        let network = NetworkAdapter(routeModel: routeModel)

        await network.request(with: [MatchItemListModel].self) { [weak self] response, error in

            switch error {

            case .invalidEndpoint:
                print("endpoint inválido")
                return
            case .parsingError:
                print("model inválido")
                return
            case .unableToGenerateRequest:
                print("não conseguimos exibir resultados")
                return
            case .some(.outsideOfSuccessRange):
                print("Verifique se você possui autorização para esse recurso")
            case .none:
                break
            }

            guard let self = self else { return }
            guard let response = response else { return }

            if matchStatus == .upcoming {

                if response.isEmpty {
                    reachedLimit = true
                    return
                } else {
                    currentPage = currentPage + 1
                }
            }

            self.matchList.append(contentsOf: response)

            self.matchList.enumerated().forEach { (matchIndex, match) in
                self.group.enter()

                if matchStatus == .running {
                    self.matchList[matchIndex].begin_at = "now"
                }
                
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
