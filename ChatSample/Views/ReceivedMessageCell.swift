//
//  ReceivedMessageCell.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation
import UIKit

class ReceivedMessageCell: UITableViewCell {
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.isOpaque = true
        return label
    }()

    let messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(text: String, name: String, imagePath: String?) {
        messageLabel.text = text
        nameLabel.text = name
        if let imagePath = imagePath {

        } else {
            let placeholder = UIImage(named: "placeholder", in: Bundle.chat, compatibleWith: nil)
            profileImage.image = placeholder
        }
    }

    private func setupConstraints() {
        contentView.addViewsForAutoLayout(views: [nameLabel, profileImage, bubbleView, messageLabel])

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 5),
            nameLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 50),
            nameLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -50),
            nameLabel.heightAnchor.constraint(equalToConstant: 16),

            profileImage.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 20),
            profileImage.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 7),
            profileImage.heightAnchor.constraint(equalToConstant: 36),
            profileImage.widthAnchor.constraint(equalToConstant: 36),

            bubbleView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            bubbleView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -5),
            bubbleView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 50),
            bubbleView.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor,
                constant: -90),

            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5),
            messageLabel.leadingAnchor.constraint(
                equalTo: bubbleView.leadingAnchor,
                constant: 10),
            messageLabel.trailingAnchor.constraint(
                equalTo: bubbleView.trailingAnchor,
                constant: -10),
            messageLabel.bottomAnchor.constraint(
                equalTo: bubbleView.bottomAnchor,
                constant: -5)
            ])
    }
}
