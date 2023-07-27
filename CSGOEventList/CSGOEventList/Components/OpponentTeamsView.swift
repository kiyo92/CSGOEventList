//
//  OpponentsTeamsView.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 26/07/23.
//

import UIKit

class OpponentTeamsView: UIView {

    private lazy var homeImageView: UIImageView = {

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "emptyLogo")

        return imageView
    }()

    private lazy var homeLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "TBD"

        return label
    }()

    private lazy var versusLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "VS"
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)

        return label
    }()

    private lazy var visitorImageView: UIImageView = {

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "emptyLogo")

        return imageView
    }()

    private lazy var visitorLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "TBD"

        return label
    }()

    init(homeImage: UIImage?,
         homeName: String,
         visitorImage: UIImage?,
         visitorName: String) {

        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        self.homeImageView.image = homeImage
        self.visitorImageView.image = visitorImage
        self.homeLabel.text = homeName
        self.visitorLabel.text = visitorName

        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHierarchy() {

        addSubview(homeImageView)
        addSubview(homeLabel)
        addSubview(versusLabel)
        addSubview(visitorImageView)
        addSubview(visitorLabel)

    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([

            homeImageView.topAnchor.constraint(equalTo: topAnchor),
            homeImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -16),
            homeImageView.trailingAnchor.constraint(equalTo: versusLabel.leadingAnchor, constant: -20),
            homeImageView.heightAnchor.constraint(equalToConstant: 60),
            homeImageView.widthAnchor.constraint(equalToConstant: 60),

            homeLabel.topAnchor.constraint(equalTo: homeImageView.bottomAnchor, constant: 10),
            homeLabel.centerXAnchor.constraint(equalTo: homeImageView.centerXAnchor),
            homeLabel.widthAnchor.constraint(equalToConstant: 80),
            homeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            homeLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            versusLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -16),
            versusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            visitorImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -16),
            visitorImageView.leadingAnchor.constraint(equalTo: versusLabel.trailingAnchor, constant: 20),
            visitorImageView.heightAnchor.constraint(equalToConstant: 60),
            visitorImageView.widthAnchor.constraint(equalToConstant: 60),

            visitorLabel.topAnchor.constraint(equalTo: visitorImageView.bottomAnchor, constant: 10),
            visitorLabel.centerXAnchor.constraint(equalTo: visitorImageView.centerXAnchor),
            visitorLabel.widthAnchor.constraint(equalToConstant: 80),
            visitorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            visitorLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func prepareForReuse() {

        homeImageView.image = nil
        homeLabel.text = ""
        visitorImageView.image = nil
        visitorLabel.text = ""
    }
}
