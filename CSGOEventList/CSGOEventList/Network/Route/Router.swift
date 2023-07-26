//
//  Router.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 25/07/23.
//

import Foundation

class Router: RouteProtocol {

    private let route: RouteModel

    init(route: RouteModel) {

        self.route = route
    }

    func getRoute() -> RouteModel {

        return self.route
    }
}
