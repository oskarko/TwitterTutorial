//
//  EditProfileCell.swift
//  TwitterTutorial
//
//  Created by Oscar Rodriguez Garrucho on 13/11/20.
//  Copyright © 2020 Oscar Rodriguez Garrucho. All rights reserved.
//

import UIKit

protocol EditProfileCellDelegate: class {
    func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UITableViewCell {

    // MARK: - Properties

    var viewModel: EditProfileViewModel? {
        didSet { configure() }
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    lazy var infoTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .left
        tf.textColor = .twitterBlue
        tf.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        return tf
    }()

    let bioTextView: CaptionTextView = {
        let tv = CaptionTextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = .twitterBlue
        tv.placeholderLabel.text = "Bio"
        return tv
    }()

    weak var delegate: EditProfileCellDelegate?

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        contentView.addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(top: topAnchor,
                          left: leftAnchor,
                          paddingTop: 12,
                          paddingLeft: 16)

        contentView.addSubview(infoTextField)
        infoTextField.anchor(top: topAnchor,
                             left: titleLabel.rightAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             paddingTop: 4,
                             paddingLeft: 16,
                             paddingBottom: 8)

        contentView.addSubview(bioTextView)
        bioTextView.anchor(top: topAnchor,
                           left: titleLabel.rightAnchor,
                           bottom: bottomAnchor,
                           right: rightAnchor,
                           paddingTop: 4,
                           paddingLeft: 14,
                           paddingBottom: 8)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleUpdateUserInfo),
                                               name: UITextView.textDidEndEditingNotification,
                                               object: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors

    @objc func handleUpdateUserInfo() {
        delegate?.updateUserInfo(self)
    }
    
    // MARK: - Helpers

    func configure() {
        guard let viewModel = viewModel else { return }

        infoTextField.isHidden = viewModel.shouldHideTextField
        bioTextView.isHidden = viewModel.shouldHideTextView

        titleLabel.text = viewModel.titleText

        infoTextField.text = viewModel.optionValue
        bioTextView.text = viewModel.optionValue
        bioTextView.placeholderLabel.isHidden = viewModel.shouldHidePlaceholderLabel
    }
}
