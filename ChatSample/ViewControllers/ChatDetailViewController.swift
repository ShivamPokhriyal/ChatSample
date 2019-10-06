//
//  ChatDetailViewController.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import UIKit

class ChatDetailViewController: UIViewController {

    let viewModel: ChatDetailViewModel

    let sentCellId = "SentMessageCell"
    let receivedCellId = "ReceivedMessageCell"

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 60
        return tableView
    }()

    let chatBar = ChatBar(frame: .zero)

    lazy var chatBarBottomConstraint = chatBar.bottomAnchor.constraint(equalTo: bottomAnchor)
    lazy var chatBarHeightConstraint = chatBar.heightAnchor.constraint(equalToConstant: 41)

    init(userId: String) {
        viewModel = ChatDetailViewModel(userId: userId)
        super.init(nibName: nil, bundle: nil)
        chatBar.delegate = self
        prepareTableView()
        setupConstraint()
        addObserver()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeObserver()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.prepareController()
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil,
            using: { [weak self] notification in
                let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                guard
                    let weakSelf = self,
                    let keyboardSize = (keyboardFrame as? NSValue)?.cgRectValue
                else {
                    return
                }
                let keyboardHeight = -(keyboardSize.height - weakSelf.view.safeAreaInsets.bottom)
                if weakSelf.chatBarBottomConstraint.constant == keyboardHeight { return }

                weakSelf.chatBarBottomConstraint.constant = keyboardHeight
            }
        )

        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil,
            using: { [weak self] notification in
                guard let weakSelf = self else { return }
                weakSelf.chatBarBottomConstraint.constant = 0
                let duration = (notification
                    .userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?
                    .doubleValue ?? 0.05

                UIView.animate(withDuration: duration, animations: {
                    weakSelf.view?.layoutIfNeeded()
                }, completion: { _ in })
            }
        )
    }

    private func removeObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }

    private func setupConstraint() {
        self.navigationItem.title = viewModel.user?.displayName
        view.backgroundColor = .white
        view.addViewsForAutoLayout(views: [tableView, chatBar])
        NSLayoutConstraint.activate([
            chatBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            chatBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            chatBarBottomConstraint,
            chatBarHeightConstraint,

            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: chatBar.topAnchor, constant: -5)
            ])
    }

    @objc private func tableTapped() {
        view.endEditing(true)
    }

    private func prepareTableView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        gesture.numberOfTapsRequired = 1
        tableView.addGestureRecognizer(gesture)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SentMessageCell.self, forCellReuseIdentifier: sentCellId)
        tableView.register(ReceivedMessageCell.self, forCellReuseIdentifier: receivedCellId)
    }

}

extension ChatDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let message = viewModel.message(at: indexPath.row) else {
            return UITableViewCell()
        }
        if message.type == Message.MessageType.Sent.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: sentCellId, for: indexPath) as? SentMessageCell else {
                return UITableViewCell()
            }
            cell.update(text: message.message!)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: receivedCellId, for: indexPath) as? ReceivedMessageCell else {
                return UITableViewCell()
            }
            cell.update(text: message.message!, name: viewModel.user!.displayName, imagePath: nil)
            return cell
        }
    }
}

extension ChatDetailViewController: ChatBarDelegate {
    func updateChatBarHeight(_ height: CGFloat) {
        if chatBarHeightConstraint.constant != height {
            chatBarHeightConstraint.constant = height
        }
    }

    func sendMessage(text: String) {
        print("Send message")
    }

    func attachmentTapped() {
        print("Open attachment")
    }
}
