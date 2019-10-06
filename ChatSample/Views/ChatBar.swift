//
//  ChatBar.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation
import UIKit

protocol ChatBarDelegate {
    func updateChatBarHeight(_ height: CGFloat)
    func sendMessage(text: String)
    func attachmentTapped()
}

class ChatBar: UIView {

    let textView: UITextView = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4.0
        let view = UITextView()
        view.backgroundColor = .clear
        view.scrollsToTop = false
        view.autocapitalizationType = .sentences
        view.typingAttributes = [.paragraphStyle: style,
                                 .font: UIFont.systemFont(ofSize: 16)]
        return view
    }()

    let placeHolder: UITextView = {
        let view = UITextView()
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.lightGray
        view.text = "Start typing..."
        view.isUserInteractionEnabled = false
        view.isScrollEnabled = false
        view.scrollsToTop = false
        view.backgroundColor = .clear
        return view
    }()

    let sendButton: UIButton = {
        let button = UIButton(type: .custom)
        var image = UIImage(named: "send", in: Bundle.chat, compatibleWith: nil)
        image = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .blue
        button.isEnabled = false
        return button
    }()

    let attachmentButton: UIButton = {
        let button = UIButton(type: .custom)
        var image = UIImage(named: "attachment", in: Bundle.chat, compatibleWith: nil)
        image = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        return button
    }()

    let lineView: UIView = {
        let view = UIView()
        /// very light gray
        view.backgroundColor = UIColor(red: 200.0 / 255.0, green: 199.0 / 255.0, blue: 204.0 / 255.0, alpha: 0.33)
        return view
    }()

    var delegate: ChatBarDelegate?

    let textViewMinHeight: CGFloat = 40
    let textViewMaxHeight: CGFloat = 110

    lazy var textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: textViewMinHeight)

    override init(frame: CGRect) {
        super.init(frame: frame)
        textView.delegate = self
        setupConstraint()
        setupActions()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraint() {
        addViewsForAutoLayout(views: [textView, placeHolder, sendButton, attachmentButton, lineView])

        NSLayoutConstraint.activate([
            attachmentButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            attachmentButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            attachmentButton.widthAnchor.constraint(equalToConstant: 30),
            attachmentButton.heightAnchor.constraint(equalToConstant: 30),

            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            sendButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 30),
            sendButton.heightAnchor.constraint(equalToConstant: 30),

            textView.leadingAnchor.constraint(equalTo: attachmentButton.trailingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textViewHeightConstraint,

            placeHolder.leadingAnchor.constraint(equalTo: attachmentButton.trailingAnchor, constant: 10),
            placeHolder.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            placeHolder.topAnchor.constraint(equalTo: topAnchor),
            placeHolder.heightAnchor.constraint(equalToConstant: textViewMinHeight),

            lineView.topAnchor.constraint(equalTo: topAnchor),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
            ])
    }

    fileprivate func clearTextView() {
        sendButton.isEnabled = false
        placeHolder.isHidden = false
        placeHolder.alpha = 1.0
        textView.inputView = nil
        textView.reloadInputViews()
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.textViewHeightConstraint.constant = weakSelf.textViewMinHeight
        }
    }

    @objc private func tapped(_ sender: UIButton) {
        switch sender {
        case sendButton:
            print("Send message")
            delegate?.sendMessage(text: textView.text)
            textView.text = ""
            clearTextView()
        case attachmentButton:
            print("Send attachment")
            delegate?.attachmentTapped()
        default:
            print("Do nothing")
        }
    }

    private func setupActions() {
        sendButton.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        attachmentButton.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
    }
}

extension ChatBar: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            clearTextView()
            delegate?.updateChatBarHeight(textViewMinHeight)
        } else {
            placeHolder.isHidden = true
            placeHolder.alpha = 0
            sendButton.isEnabled = true
            updateTextViewHeight(textView)
            delegate?.updateChatBarHeight(textViewHeightConstraint.constant + 1)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            clearTextView()
        }
    }

    private func updateTextViewHeight(_ textView: UITextView) {
        let attributes = textView.typingAttributes
        let tv = UITextView(frame: textView.frame)
        tv.attributedText = NSAttributedString(string: textView.text, attributes: attributes)

        let fixedWidth = textView.frame.size.width
        let size = tv.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

        if textViewHeightConstraint.constant != size.height {
            if size.height < textViewMaxHeight {
                textViewHeightConstraint.constant = max(size.height, textViewMinHeight)
            } else if textViewHeightConstraint.constant != textViewMaxHeight {
                textViewHeightConstraint.constant = textViewMaxHeight
            }
        }
    }

}
