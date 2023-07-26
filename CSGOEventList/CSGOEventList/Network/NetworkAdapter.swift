//
//  NetworkAdapter.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 25/07/23.
//

import Foundation

class NetworkAdapter {

    enum NetworkError: Error {
        case unabeToGenerateRequest
        case invalidEndpoint
        case parsingError
    }

    let route: RouteProtocol

    init(routeModel: RouteModel) {

        let route = Router(route: routeModel)
        self.route = route
    }

    func request<T:Decodable>(with type: T.Type, completion: @escaping(T?, NetworkError?) -> Void) async {

        let requestConfigs = self.route.getRoute()

        let session = URLSession.shared

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.pandascore.co"
        components.queryItems = requestConfigs.queryParameters
        components.path = requestConfigs.path.getPath()

        guard let url = components.url else { return }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = requestConfigs.headers
        request.httpMethod = requestConfigs.method?.rawValue.uppercased()

        let response = session.dataTask(with: request) { data, response, error in

            guard response != nil else {
                completion(nil, .invalidEndpoint)
                return
            }

            do {
                let result = try JSONDecoder().decode(T.self, from: data ?? Data())
                completion(result, nil)
            } catch {
                completion(nil, .parsingError)
            }
        }

        response.resume()
    }

    func request(completion: @escaping(Data?, URLResponse?, Error?) -> Void) {

        let requestConfigs = self.route.getRoute()
        if let imageUrl = URL(string: requestConfigs.path.getPath()) {
            
            URLSession.shared.dataTask(with: imageUrl, completionHandler: completion).resume()
        }
    }
}
