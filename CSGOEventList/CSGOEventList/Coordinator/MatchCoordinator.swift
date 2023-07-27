//
//  MatchCoordinator.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 27/07/23.
//

import Foundation
import UIKit

class MatchCoordinator: Coordinator {

    weak var parent: Coordinator?
    var children = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {

        self.navigationController = navigationController
    }

    func start() {}

    func start(with match: MatchItemListModel) {

        let viewModel = MatchViewModel()
        let vc = MatchDetailsViewController(match: match,
                                            viewModel: viewModel)
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: false)
    }

    func dismiss() {

        navigationController.popViewController(animated: true)
    }

    func dismissCoordinator() {
        let parent = self.parent as? HomeCoordinator
        parent?.dismissChildCoordinator(with: self)
    }
}
