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
        tableView.isHidden = true
        return tableView
    }()

    let chatBar = ChatBar(frame: .zero)

    lazy var chatBarBottomConstraint = chatBar.bottomAnchor.constraint(equalTo: bottomAnchor)
    lazy var chatBarHeightConstraint = chatBar.heightAnchor.constraint(equalToConstant: 41)

    init(userId: String) {
        viewModel = ChatDetailViewModel(userId: userId)
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
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
                let rows = weakSelf.viewModel.numberOfRows(in: 0)
                if rows > 0 {
                    DispatchQueue.main.async {
                        weakSelf.tableView.scrollToRow(
                            at: IndexPath(row: rows - 1, section: 0),
                            at: .bottom,
                            animated: false)
                    }
                }
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

            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
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

// MARK: tableview datasource and delegates
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
        if message.type == Message.MessageType.sent.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: sentCellId, for: indexPath) as? SentMessageCell else {
                return UITableViewCell()
            }
            cell.update(model: message)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: receivedCellId, for: indexPath) as? ReceivedMessageCell else {
                return UITableViewCell()
            }
            cell.update(model: message, user: viewModel.user!)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let message = viewModel.message(at: indexPath.row) else {
            return 0
        }
        if message.type == Message.MessageType.sent.rawValue {
            return SentMessageCell.rowHeight(model: message)
        } else {
            return ReceivedMessageCell.rowHeight(model: message)
        }
    }
}

// MARK: chat bar delegate
extension ChatDetailViewController: ChatBarDelegate {
    func updateChatBarHeight(_ height: CGFloat) {
        if chatBarHeightConstraint.constant != height {
            chatBarHeightConstraint.constant = height
        }
    }

    func sendMessage(text: String) {
        viewModel.sendText(text)
    }

    func attachmentTapped() {
        let pickerVC = UIImagePickerController()
        pickerVC.delegate = self
        pickerVC.sourceType = .photoLibrary
        present(pickerVC, animated: true, completion: nil)
    }
}

// MARK: image picker delegate
extension ChatDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        let filePath = saveImage(image)
        viewModel.sendAttachment(filePath)
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    private func saveImage(_ image: UIImage) -> String {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = String(format: "IMG-%f.jpeg", Date().timeIntervalSince1970)
        let path = documentsURL.appendingPathComponent(fileName).path
        let data = ImageUtil().compress(image: image) as NSData?
        data?.write(toFile: path, atomically: true)
        return fileName
    }
}

// MARK: viewmodel delegate
extension ChatDetailViewController: ChatDetailDelegate {
    func messagesLoaded() {
        tableView.reloadData()
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: IndexPath(row: self.viewModel.numberOfRows(in: 0) - 1, section: 0), at: .bottom, animated: false)
            self.tableView.isHidden = false
        }
    }

    func loadingError() {
        let alert = UIAlertController(title: "Error", message: "Some error occured while loading conversation", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            guard let weakSelf = self else { return }
            weakSelf.viewModel.prepareController()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func messageAdded(at position: Int) {
        guard position >= tableView.numberOfSections else {
            return
        }
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: position, section: 0)], with: .automatic)
        tableView.endUpdates()
        tableView.scrollToRow(at: IndexPath(row: position, section: 0), at: .bottom, animated: false)
    }

    func messageSendError() {
        let alert = UIAlertController(title: "Error", message: "Couldn't send message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
