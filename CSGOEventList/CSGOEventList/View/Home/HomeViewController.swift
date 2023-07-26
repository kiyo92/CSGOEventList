//
//  HomeViewController.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 25/07/23.
//

import UIKit

class HomeViewController: UIViewController {

    private var viewModel: HomeViewModel

    private lazy var titleLabel: UILabel = {

        let label = UILabel()
        label.text = "Partidas"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .medium)
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

        return label
    }()

    private lazy var tableView: UITableView = {

        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MatchListTableViewCell.self, forCellReuseIdentifier: "MatchListTableViewCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 0.086, green: 0.086, blue: 0.129, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0.086, green: 0.086, blue: 0.129, alpha: 1)
        setupHierarchy()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        Task {

            await viewModel.getUpcomingMatches { [weak self] _ in

                guard let self = self else { return }

                tableView.reloadData()
            }
        }
    }

    private func setupHierarchy() {

        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.matchList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MatchListTableViewCell",
                                                       for: indexPath) as? MatchListTableViewCell
        else { return UITableViewCell() }

        DispatchQueue.main.async {

            let opponents = self.viewModel.matchList[indexPath.row].opponents ?? []
            let date = self.viewModel.matchList[indexPath.row].begin_at ?? ""
            let league = self.viewModel.matchList[indexPath.row].league
            cell.setup(with: opponents,
                       date: date,
                       league: league)
        }

        return cell
    }
}
