//
//  EditProfileHeader.swift
//  TwitterTutorial
//
//  Created by Oscar Rodriguez Garrucho on 13/11/20.
//  Copyright © 2020 Oscar Rodriguez Garrucho. All rights reserved.
//

import UIKit

protocol EditProfileHeaderDelegate: class {
    func didTapChangeProfilePhoto()
}

class EditProfileHeader: UIView {

    // MARK: - Properties

    private let user: User
    weak var delegate: EditProfileHeaderDelegate?

    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 3.0
        iv.setDimensions(width: 100, height: 100)
        iv.layer.cornerRadius = 100 / 2
        return iv
    }()

    private let changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Profile Photo", for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfilePhoto), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        return button
    }()


    // MARK: - Lifecycle

    init(user: User) {
        self.user = user
        super.init(frame: .zero)

        backgroundColor = .twitterBlue

        addSubview(profileImageView)
        profileImageView.center(inView: self, yConstant: -16)

        addSubview(changePhotoButton)
        changePhotoButton.centerX(inView: self,
                                  topAnchor: profileImageView.bottomAnchor,
                                  paddingTop: 8)

        profileImageView.sd_setImage(with: user.profileImageUrl)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors

    @objc func handleChangeProfilePhoto() {
        delegate?.didTapChangeProfilePhoto()
    }
}
