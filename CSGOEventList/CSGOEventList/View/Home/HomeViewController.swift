//
//  HomeViewController.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 25/07/23.
//

import UIKit

class HomeViewController: UIViewController {

    weak var coordinator: HomeCoordinator?
    private var viewModel: HomeViewModel

    private lazy var loading: UIActivityIndicatorView = {

        let loading = UIActivityIndicatorView(style: .large)
        loading.hidesWhenStopped = true
        loading.color = .darkGray
        loading.translatesAutoresizingMaskIntoConstraints = false

        return loading
    }()

    private lazy var titleLabel: UILabel = {

        let label = UILabel()
        label.text = "Partidas"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .medium)
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

        return label
    }()

    let refreshControl = UIRefreshControl()

    private lazy var tableView: UITableView = {

        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MatchListTableViewCell.self, forCellReuseIdentifier: "MatchListTableViewCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 0.086, green: 0.086, blue: 0.129, alpha: 1)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = .white
        tableView.refreshControl = refreshControl
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

        getMatches()
    }

    private func getMatches(isReload: Bool = false) {

        loading.startAnimating()
        let group = DispatchGroup()

        group.enter()
        Task {

            await viewModel.getMatches(matchStatus: .running, isReload: isReload) { _ in

                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in

            guard let self = self else { return }

            Task {

                await self.getUpcomingMatches()
            }
        }
    }

    private func getUpcomingMatches() async {

        await viewModel.getMatches(matchStatus: .upcoming) { [weak self] _ in

            guard let self = self else { return }

            refreshControl.endRefreshing()
            self.loading.stopAnimating()
            self.tableView.reloadData()
        }
    }

    private func setupHierarchy() {

        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(loading)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([

            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    @objc
    private func refresh() {

        getMatches()
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        coordinator?.matchDetail(with: viewModel.matchList[indexPath.row])
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row + 1 == viewModel.matchList.count {

            Task {
                
                await getUpcomingMatches()
            }
        }
    }
}
