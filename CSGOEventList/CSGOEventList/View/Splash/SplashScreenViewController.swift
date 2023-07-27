//
//  SplashScreenViewController.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 27/07/23.
//

import UIKit

class SplashScreenViewController: UIViewController {

    var coordinator: HomeCoordinator?
    var navController: UINavigationController

    private lazy var splashImage: UIImageView = {

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "fuzeLogo")

        return imageView
    }()

    init(navigationController: UINavigationController) {

        self.navController = navigationController
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0.09, green: 0.09, blue: 0.13, alpha: 1)
        createHierarchy()
        createConstraints()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in

            guard let self = self else { return }
            
            self.coordinator = HomeCoordinator(navigationController: self.navController)
            self.coordinator?.start()
        }
    }

    private func createHierarchy() {

        view.addSubview(splashImage)
    }

    private func createConstraints() {

        NSLayoutConstraint.activate([

            splashImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImage.heightAnchor.constraint(equalToConstant: 113),
            splashImage.widthAnchor.constraint(equalToConstant: 113),
        ])
    }
}
