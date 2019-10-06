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
        view.addViewsForAutoLayout(views: [tableView])
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }

    private func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatListCell.self, forCellReuseIdentifier: cellIdentifier)
    }

}

// MARK: tableview datasource and delegate
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

// MARK: viewmodel delegate
extension HomeViewController: HomeViewModelDelegate {
    func chatLoaded() {
        tableView.isHidden = false
        tableView.reloadData()
    }

    func loadingError() {
        tableView.isHidden = true
        let alert = UIAlertController(title: "Error", message: "Some error occured while loading conversation", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            guard let weakSelf = self else { return }
            weakSelf.viewModel.prepareController()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
