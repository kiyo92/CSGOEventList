//
//  CustomPath.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 25/07/23.
//

import Foundation

class CustomPath: PathProtocol {

    private var path: String

    init(absolutePath: String) {

        self.path = absolutePath
    }

    func getPath() -> String {

        return self.path
    }
}
