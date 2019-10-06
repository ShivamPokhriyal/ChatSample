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
        label.isHidden = true
        return label
    }()

    let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        view.clipsToBounds = true
        return view
    }()

    let photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(model: Message, user: User) {
        if let filePath = model.filePath {
            let docDirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let path = docDirPath.appendingPathComponent(filePath)
            let data = try! Data(contentsOf: path)
            let image = UIImage(data: data)
            photoView.image = image
            photoView.isHidden = false
            messageLabel.isHidden = true
            bubbleView.isHidden = true
        } else {
            messageLabel.text = model.message ?? "Attachment"
            photoView.isHidden = true
            messageLabel.isHidden = false
            bubbleView.isHidden = false
        }
        nameLabel.text = user.displayName
        if let imagePath = user.imageUrl {
            let docDirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let path = docDirPath.appendingPathComponent(imagePath)
            let data = try! Data(contentsOf: path)
            profileImage.image = UIImage(data: data)
        } else {
            let placeholder = UIImage(named: "placeholder", in: Bundle.chat, compatibleWith: nil)
            profileImage.image = placeholder
        }
    }

    class func rowHeight(model: Message) ->CGFloat {
        if model.filePath != nil {
            return 191
        }
        let text = model.message ?? "Attachment"
        let width = UIScreen.main.bounds.width - 120
        return text.heightWithConstrainedWidth(width, font: UIFont.systemFont(ofSize: 14)) + 41
    }

    private func setupConstraints() {
        contentView.addViewsForAutoLayout(views: [nameLabel, profileImage, bubbleView, messageLabel, photoView])

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
                constant: -5),

            photoView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            photoView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 50),
            photoView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            photoView.heightAnchor.constraint(equalToConstant: 150)
            ])
    }
}
