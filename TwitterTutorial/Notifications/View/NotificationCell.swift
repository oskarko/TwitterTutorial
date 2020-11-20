//
//  NotificationCell.swift
//  TwitterTutorial
//
//  Created by Oscar Rodriguez Garrucho on 29/10/20.
//  Copyright © 2020 Oscar Rodriguez Garrucho. All rights reserved.
//

import UIKit
import SDWebImage

protocol NotificationCellDelegate: class {
    func didTapProfileImage(_ cell: NotificationCell)
    func didTapFollow(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {

    // MARK: - Properties

    var notification: Notification? {
        didSet { configure() }
    }

    weak var delegate: NotificationCellDelegate?

    private lazy var profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40 / 2
        iv.backgroundColor = .twitterBlue

        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true

        return iv
    }()

    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setDimensions(width: 92, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(handleFollowButtonTapped), for: .touchUpInside)

        return button
    }()

    let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Some test notification message"

        return label
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let stack = UIStackView(arrangedSubviews: [profileImageView, notificationLabel])
        stack.spacing = 8
        stack.alignment = .center

        contentView.addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        stack.anchor(right: rightAnchor, paddingRight: 12)

        contentView.addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right: rightAnchor, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selector

    @objc func handleProfileImageTapped() {
        delegate?.didTapProfileImage(self)
    }

    @objc func handleFollowButtonTapped() {
        delegate?.didTapFollow(self)
    }

    // MARK: - Helpers

    func configure() {
        guard let notification = notification else { return }

        let viewModel = NotificationViewModel(notification: notification)

        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        notificationLabel.attributedText = viewModel.notificationText

        followButton.isHidden = viewModel.shouldHideFollowButton
        followButton.setTitle(viewModel.followButtonText, for: .normal)
    }
}
