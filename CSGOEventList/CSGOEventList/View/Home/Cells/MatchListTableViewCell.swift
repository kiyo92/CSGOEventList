//
//  MatchListTableViewCell.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 25/07/23.
//

import UIKit

class MatchListTableViewCell: UITableViewCell {

    private lazy var container: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.22, alpha: 1)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true

        return view
    }()

    private lazy var dateContainer: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.979, green: 0.979, blue: 0.979, alpha: 0.2)
        view.layer.cornerRadius = 12

        return view
    }()

    private lazy var dateLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 9, weight: .bold)
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

        return label
    }()

    private var opponentTeamsView: OpponentTeamsView = OpponentTeamsView(homeImage: nil,
                                                                         homeName: "",
                                                                         visitorImage: nil,
                                                                         visitorName: "")

    private lazy var separator: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)

        return view
    }()

    private lazy var leagueImageView: UIImageView = {

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "emptyLogo")

        return imageView
    }()

    private lazy var leagueNameLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "League + serie"
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

        return label
    }()

    var opponents: [MatchOpponentListModel] = []
    var date: String = ""
    var league: MatchLeagueModel?

    func setup(with opponents: [MatchOpponentListModel],
               date: String,
               league: MatchLeagueModel?) {

        self.opponents = opponents
        self.date = date
        self.league = league

        selectionStyle = .none
        setupOpponents()
        setupLeague()
        setupHierarchy()
        setupConstraint()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        backgroundColor = .clear
    }

    override func layoutSubviews() {
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear

    }

    private func setupHierarchy() {

        contentView.addSubview(container)
        container.addSubview(dateContainer)
        dateContainer.addSubview(dateLabel)
        container.addSubview(opponentTeamsView)
        container.addSubview(separator)
        container.addSubview(leagueImageView)
        container.addSubview(leagueNameLabel)
    }

    private func setupConstraint() {

        let containerHeight = container.heightAnchor.constraint(equalToConstant: 176)
        containerHeight.priority = UILayoutPriority(rawValue: 999)

        NSLayoutConstraint.activate([

            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerHeight,

            dateContainer.topAnchor.constraint(equalTo: container.topAnchor, constant: -12),
            dateContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 16),

            dateLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: dateContainer.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: dateContainer.bottomAnchor, constant: -8),

            opponentTeamsView.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -16),
            opponentTeamsView.centerXAnchor.constraint(equalTo: container.centerXAnchor),

            separator.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -32),
            separator.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),

            leagueImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            leagueImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            leagueImageView.widthAnchor.constraint(equalToConstant: 16),
            leagueImageView.heightAnchor.constraint(equalToConstant: 16),

            leagueNameLabel.centerYAnchor.constraint(equalTo: leagueImageView.centerYAnchor),
            leagueNameLabel.leadingAnchor.constraint(equalTo: leagueImageView.trailingAnchor, constant: 8),

        ])
    }

    private func setupOpponents() {

        var homeImage: UIImage? = UIImage(named: "emptyLogo")
        var visitorImage: UIImage? = UIImage(named: "emptyLogo")
        var homeName: String = "TBD"
        var visitorName: String = "TBD"

        for (index, opponent) in opponents.enumerated() {

            if index == 0 {

                homeImage = UIImage(data: opponent.imageData ?? Data())
                if let name = opponent.opponent?.name {

                    homeName = name
                }

            } else if index == 1 {

                visitorImage = UIImage(data: opponent.imageData ?? Data())
                if let name = opponent.opponent?.name {

                    visitorName = name
                }
            }
        }

        self.opponentTeamsView = OpponentTeamsView(homeImage: homeImage,
                                                   homeName: homeName,
                                                   visitorImage: visitorImage,
                                                   visitorName: visitorName)

    }

    private func setupLeague() {

        if let leagueImage = league?.imageData {

            self.leagueImageView.image = UIImage(data: leagueImage)
        } else {

            self.leagueImageView.image = UIImage(named: "emptyLogo")
        }

        leagueNameLabel.text = league?.name ?? ""

        let date = self.date.getDateFromString()

        if date.isSevenDaysAfter() {

            self.dateLabel.text = date.getDateStringFormatted()

        } else {

            guard let dayOfWeek = date.dayOfTheWeek() else { return }
            let dayOfWeekReduced = dayOfWeek.prefix(3)
            let dayNumber = date.getDateStringFormatted().suffix(6)

            self.dateLabel.text = "\(dayOfWeekReduced),\(dayNumber)"

        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        leagueImageView.image = UIImage(named: "emptyLogo")
        dateLabel.text = ""
        leagueNameLabel.text = ""
        opponentTeamsView.removeFromSuperview()
        opponentTeamsView = OpponentTeamsView(homeImage: UIImage(named: "emptyLogo"),
                                              homeName: "TBD",
                                              visitorImage: UIImage(named: "emptyLogo"),
                                              visitorName: "TBD")
    }
}
