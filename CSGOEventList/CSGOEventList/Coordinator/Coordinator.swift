//
//  Coordinator.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 26/07/23.
//

import UIKit

public protocol Coordinator : AnyObject {

    var children: [Coordinator] { get set }

    var navigationController: UINavigationController { get set}

    func start()
}
