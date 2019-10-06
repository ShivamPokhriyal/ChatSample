//
//  ChatListCell.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation
import UIKit

class ChatListCell: UITableViewCell {

    struct Config {
        struct ProfileImage {
            static let width: CGFloat = 40
            static let height: CGFloat = 40
            static let cornerRadius: CGFloat = 15
            static let left: CGFloat = 10
        }
    }

    var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Config.ProfileImage.cornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()

    var profileName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    var message: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileName, message])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 3
        return stackView
    }()

    private var lineView: UIView = {
        let view = UIView()
        /// very light gray
        view.backgroundColor = UIColor(red: 200.0 / 255.0, green: 199.0 / 255.0, blue: 204.0 / 255.0, alpha: 0.33)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(model: ChatItem) {
        if let imageUrl = model.user.imageUrl {
            let docDirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let path = docDirPath.appendingPathComponent(imageUrl)
            let data = try! Data(contentsOf: path)
            profileImage.image = UIImage(data: data)
        } else {
            let placeholder = UIImage(named: "placeholder", in: Bundle.chat, compatibleWith: nil)
            profileImage.image = placeholder
        }
        profileName.text = model.user.displayName
        message.text = model.message.message ?? "Attachment"
    }

    private func setupConstraint() {
        contentView.addViewsForAutoLayout(views: [profileImage, stackView, lineView])

        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Config.ProfileImage.left),
            profileImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: Config.ProfileImage.width),
            profileImage.heightAnchor.constraint(equalToConstant: Config.ProfileImage.height),

            stackView.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            ])
    }
}
