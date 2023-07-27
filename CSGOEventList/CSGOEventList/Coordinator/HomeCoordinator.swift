//
//  HomeCoordinator.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 26/07/23.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {

    weak var parent: Coordinator?
    var children = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {

        self.navigationController = navigationController
    }

    func start() {

        let viewModel = HomeViewModel()
        let vc = HomeViewController(viewModel: viewModel)
        vc.coordinator = self
        self.navigationController.isNavigationBarHidden = true
        self.navigationController.pushViewController(vc, animated: false)
    }


    func matchDetail(with match: MatchItemListModel) {

        let child = MatchCoordinator(navigationController: self.navigationController)
        child.parent = self
        children.append(child)
        child.start(with: match)
    }

    func dismissChildCoordinator (with child: Coordinator?) {

        for (index, coordinator) in children.enumerated() {

            if child === coordinator {

                children.remove(at: index)
                break
            }
        }
    }
}
