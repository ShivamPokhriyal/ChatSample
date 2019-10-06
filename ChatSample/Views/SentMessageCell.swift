//
//  SentMessageCell.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation
import UIKit

class SentMessageCell: UITableViewCell {
    let messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        label.isHidden = true
        return label
    }()

    let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        return view
    }()

    let photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
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

    lazy var photoViewWidth = photoView.widthAnchor.constraint(equalToConstant: 150)

    func update(model: Message) {
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
            photoViewWidth.constant = 0
            messageLabel.text = model.message ?? "Attachment"
            photoView.isHidden = true
            messageLabel.isHidden = false
            bubbleView.isHidden = false
        }
    }

    class func rowHeight(model: Message) ->CGFloat {
        if model.filePath != nil {
            return 165
        }
        let text = model.message ?? "Attachment"
        let width = UIScreen.main.bounds.width - 120
        return text.heightWithConstrainedWidth(width, font: UIFont.systemFont(ofSize: 14)) + 15
    }

    private func setupConstraints() {
        contentView.addViewsForAutoLayout(views: [bubbleView, messageLabel, photoView])

        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bubbleView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -5),
            bubbleView.leadingAnchor.constraint(
                greaterThanOrEqualTo: contentView.leadingAnchor,
                constant: 90),
            bubbleView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -10),

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

            photoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            photoView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -10),
            photoView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            photoView.heightAnchor.constraint(equalToConstant: 150),
            ])
    }
}
