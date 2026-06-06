//
//  NewsListScreenView.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 04/06/26.
//

import UIKit

final class NewsListScreenView: UIView {

    var onSelectItem: ((String) -> Void)?
    var onSelectItemAtIndex: ((Int) -> Void)?
    var onReachEnd: (() -> Void)?

    private var items: [String] = []

    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let stateContainerView = UIView()
    private let stateImageView = UIImageView()
    private let stateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setItems(_ items: [String]) {
        self.items = items
        tableView.reloadData()
    }

    func showContent() {
        tableView.isHidden = false
        stateContainerView.isHidden = true
    }

    func hideList() {
        tableView.isHidden = true
    }

    func showLoading(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }

    func showEmptyState(iconName: String, message: String) {
        tableView.isHidden = true
        stateImageView.image = UIImage(systemName: iconName)
        stateLabel.text = message
        stateContainerView.isHidden = false
    }

    private func setupUI() {
        setupTableView()
        setupLoadingIndicator()
        setupStateView()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewsListCell")
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setupStateView() {
        stateContainerView.translatesAutoresizingMaskIntoConstraints = false
        stateContainerView.isHidden = true
        addSubview(stateContainerView)

        stateImageView.translatesAutoresizingMaskIntoConstraints = false
        stateImageView.contentMode = .scaleAspectFit
        stateImageView.tintColor = .systemGray

        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.textAlignment = .center
        stateLabel.numberOfLines = 0
        stateLabel.font = .systemFont(ofSize: 16, weight: .medium)
        stateLabel.textColor = .secondaryLabel

        stateContainerView.addSubview(stateImageView)
        stateContainerView.addSubview(stateLabel)

        NSLayoutConstraint.activate([
            stateContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stateContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stateContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stateContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            stateImageView.topAnchor.constraint(equalTo: stateContainerView.topAnchor),
            stateImageView.centerXAnchor.constraint(equalTo: stateContainerView.centerXAnchor),
            stateImageView.widthAnchor.constraint(equalToConstant: 80),
            stateImageView.heightAnchor.constraint(equalToConstant: 80),

            stateLabel.topAnchor.constraint(equalTo: stateImageView.bottomAnchor, constant: 16),
            stateLabel.leadingAnchor.constraint(equalTo: stateContainerView.leadingAnchor),
            stateLabel.trailingAnchor.constraint(equalTo: stateContainerView.trailingAnchor),
            stateLabel.bottomAnchor.constraint(equalTo: stateContainerView.bottomAnchor)
        ])
    }
}

extension NewsListScreenView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsListCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].capitalized
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let onSelectItemAtIndex {
            onSelectItemAtIndex(indexPath.row)
        } else {
            onSelectItem?(items[indexPath.row])
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !items.isEmpty, indexPath.row == items.count - 1 else { return }
        onReachEnd?()
    }
}
