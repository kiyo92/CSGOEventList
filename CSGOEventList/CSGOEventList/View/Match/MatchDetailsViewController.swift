//
//  MatchDetailsViewController.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 26/07/23.
//

import UIKit

class MatchDetailsViewController: UIViewController {

    let match: MatchItemListModel
    let viewModel: MatchViewModel
    weak var coordinator: MatchCoordinator?

    private lazy var loading: UIActivityIndicatorView = {

        let loading = UIActivityIndicatorView(style: .large)
        loading.hidesWhenStopped = true
        loading.color = .darkGray
        loading.translatesAutoresizingMaskIntoConstraints = false

        return loading
    }()

    private lazy var backButton: UIButton = {

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "backArrow"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)

        return button
    }()

    private lazy var titleLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "League + serie"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .medium)

        return label
    }()

    var opponentTeamsView: OpponentTeamsView

    private lazy var dateLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "03.19 22:00"
        label.textColor = .white

        return label
    }()

    private lazy var playersVStackView: UIStackView = {

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 15

        return stackView
    }()

    private lazy var playersHStackView: UIStackView = {

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 13

        return stackView
    }()

    init(match: MatchItemListModel,
         viewModel: MatchViewModel) {

        self.match = match

        var homeImage: UIImage? = nil
        var visitorImage: UIImage? = nil
        var homeName: String = ""
        var visitorName: String = ""

        if let opponents = match.opponents {

            for (index, opponent) in opponents.enumerated() {

                if index == 0 {
                    homeImage = UIImage(data: opponent.imageData ?? Data())
                    homeName = opponent.opponent?.name ?? ""
                } else if index == 1 {
                    visitorImage = UIImage(data: opponent.imageData ?? Data())
                    visitorName = opponent.opponent?.name ?? ""
                }
            }
        }

        self.opponentTeamsView = OpponentTeamsView(homeImage: homeImage,
                                                   homeName: homeName,
                                                   visitorImage: visitorImage,
                                                   visitorName: visitorName)

        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0.086, green: 0.086, blue: 0.129, alpha: 1)
        getTeamData()
        createLoader()
    }

    private func getTeamData() {

        let group = DispatchGroup()
        var homePlayerList: [PlayerDetailModel] = []
        var visitorPlayerList: [PlayerDetailModel] = []

        loading.startAnimating()
        guard let opponents = match.opponents else { return }

        for _ in opponents {

            group.enter()
        }

        for (index, opponent) in opponents.enumerated() {

            Task {

                await self.viewModel.getTeamData(teamID: "\(opponent.opponent?.id ?? 0)") { players in

                    DispatchQueue.main.async {

                        for player in players {

                            if index == 0 {

                                homePlayerList.append(player)
                            } else if index == 1 {

                                visitorPlayerList.append(player)

                            }
                        }
                        group.leave()
                    }
                }
            }
        }


        group.notify(queue: .main) { [weak self] in

            guard let self = self else { return }

            for (index, player) in homePlayerList.enumerated() {
                self.playersVStackView.addArrangedSubview(self.createPlayerStackView(players: [PlayerItemView(side: .left,
                                                                                                              player: player),
                                                                                               PlayerItemView(side: .right,
                                                                                                              player: visitorPlayerList[safe: index] ?? nil)]))
            }

            self.loading.stopAnimating()

            self.createHierarchy()
            self.createConstraints()
        }
    }

    private func createLoader() {

        view.addSubview(loading)
        loading.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func createHierarchy() {

        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(opponentTeamsView)
        view.addSubview(dateLabel)
        view.addSubview(playersVStackView)
    }

    private func createConstraints() {

        NSLayoutConstraint.activate([

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            opponentTeamsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            opponentTeamsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            dateLabel.topAnchor.constraint(equalTo: opponentTeamsView.bottomAnchor, constant: 20),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            playersVStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 25),
            playersVStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playersVStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playersVStackView.heightAnchor.constraint(equalToConstant: CGFloat(playersVStackView.subviews.count * 57)),
        ])
    }

    private func createPlayerStackView(players: [PlayerItemView?]) -> UIStackView {

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 13

        players.forEach { player in

            if let player = player {
                stackView.addArrangedSubview(player)
            }
        }
        return stackView
    }

    @objc
    func backButtonPressed() {

        coordinator?.dismiss()
        coordinator?.dismissCoordinator()
    }
}
