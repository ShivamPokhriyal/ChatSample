//
//  HomeViewController.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let viewModel = HomeViewModel()

    let cellIdentifier = "ChatCell"

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 60
        return tableView
    }()

    let noConversationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Couldn't load conversations🥺"
        label.font = UIFont.systemFont(ofSize: 18)
        label.isHidden = false
        return label
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SendMessage"), object: nil, queue: nil) { [weak self] notification in
            guard
                let weakSelf = self,
                let message = notification.object as? Message
                else { return }
            weakSelf.viewModel.addMessage(message)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.prepareController()
        setupView()
        prepareTableView()
    }

    private func setupView() {
        self.navigationItem.title = "Chat"
        view.addViewsForAutoLayout(views: [tableView, noConversationLabel])
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),

            noConversationLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            noConversationLabel.topAnchor.constraint(equalTo: topAnchor),
            noConversationLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            noConversationLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            noConversationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noConversationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }

    private func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatListCell.self, forCellReuseIdentifier: cellIdentifier)
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChatListCell,
            let chatItem = viewModel.chatItem(at: indexPath.row)
            else {
                return UITableViewCell()
        }
        cell.update(model: chatItem)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let chatItem = viewModel.chatItem(at: indexPath.row) else { return }
        let vc = ChatDetailViewController(userId: chatItem.message.userId)
        self.navigationController?.pushViewController(vc, animated: false)
    }

}

extension HomeViewController: HomeViewModelDelegate {
    func chatLoaded() {
        tableView.isHidden = false
        noConversationLabel.isHidden = true
        tableView.reloadData()
    }

    func loadingError() {
        tableView.isHidden = true
        noConversationLabel.isHidden = false
    }
}
