//
//  PlayerItemView.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 26/07/23.
//

import UIKit

class PlayerItemView: UIView {

    enum PlayerItemSide {

        case right
        case left
    }

    private lazy var container: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.22, alpha: 1)
        view.layer.cornerRadius = 12

        return view
    }()

    private lazy var nickNameLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nickname"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

        return label
    }()

    private lazy var playerNameLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Player name"
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.424, green: 0.42, blue: 0.494, alpha: 1)

        return label
    }()

    private lazy var playerImageView: UIImageView = {

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "emptyProfile")

        return imageView
    }()

    private let side: PlayerItemSide

    init(side: PlayerItemSide, player: PlayerDetailModel?) {

        self.side = side
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        if let player = player {

            self.nickNameLabel.text = player.name
            self.playerNameLabel.text = "\(player.firstName ?? "") \(player.lastName ?? "")"
            setupHierarchy()
            setupConstraints()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHierarchy() {

        addSubview(container)

        switch side {

        case .left:
            container.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        case .right:
            container.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }

        container.addSubview(nickNameLabel)
        container.addSubview(playerNameLabel)
        container.addSubview(playerImageView)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([

            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.heightAnchor.constraint(equalToConstant: 54),

            nickNameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 15),

            playerNameLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor),

            playerImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: -3),
            playerImageView.widthAnchor.constraint(equalToConstant: 48),
            playerImageView.heightAnchor.constraint(equalToConstant: 48),
        ])

        switch side {

        case .left:
            NSLayoutConstraint.activate([

                nickNameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
                nickNameLabel.trailingAnchor.constraint(equalTo: playerImageView.leadingAnchor, constant: -16),

                playerNameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
                playerNameLabel.trailingAnchor.constraint(equalTo: playerImageView.leadingAnchor, constant: -16),

                playerImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            ])
        case .right:
            NSLayoutConstraint.activate([

                nickNameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
                nickNameLabel.leadingAnchor.constraint(equalTo: playerImageView.trailingAnchor, constant: 16),

                playerNameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
                playerNameLabel.leadingAnchor.constraint(equalTo: playerImageView.trailingAnchor, constant: 16),

                playerImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: -3),
                playerImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),

            ])
        }
    }
}
