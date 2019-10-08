//
//  ContactCell.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 08/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class ContactCell: UITableViewCell {

    struct Config {
        struct ProfileImage {
            static let width: CGFloat = 26
            static let height: CGFloat = 26
            static let cornerRadius: CGFloat = 13
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

    func update(text: String, image: UIImage, font: UIFont, color: UIColor) {
        profileName.text = text
        profileName.font = font
        profileName.textColor = color
        profileImage.image = image
    }

    func update(contact: CNContact) {
        profileName.text = "\(contact.givenName) \(contact.familyName)"
        let placeholder = UIImage(named: "placeholder", in: Bundle.chat, compatibleWith: nil)
        profileImage.image = placeholder
        profileName.font = UIFont.boldSystemFont(ofSize: 12)
        profileName.textColor = .black
//        if let imageUrl = user.imageUrl {
//            let docDirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let path = docDirPath.appendingPathComponent(imageUrl)
//            let data = try! Data(contentsOf: path)
//            profileImage.image = UIImage(data: data)
//        } else {
//            let placeholder = UIImage(named: "placeholder", in: Bundle.chat, compatibleWith: nil)
//            profileImage.image = placeholder
//        }
//        profileName.text = user.displayName
    }

    private func setupConstraint() {
        contentView.addViewsForAutoLayout(views: [profileImage, profileName, lineView])

        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Config.ProfileImage.left),
            profileImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: Config.ProfileImage.width),
            profileImage.heightAnchor.constraint(equalToConstant: Config.ProfileImage.height),

            profileName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10),
            profileName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profileName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            profileName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            ])
    }
}

