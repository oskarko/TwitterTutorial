//
//  EditProfileFooter.swift
//  TwitterTutorial
//
//  Created by Oscar Rodriguez Garrucho on 17/11/20.
//  Copyright © 2020 Oscar Rodriguez Garrucho. All rights reserved.
//

import UIKit

protocol EditProfileFooterDelegate: class {
    func handleLogout()
}

class EditProfileFooter: UIView {

    // MARK: - Properties

    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)

        return button
    }()

    weak var delegate: EditProfileFooterDelegate?

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(logoutButton)
        logoutButton.anchor(left: leftAnchor,
                            right: rightAnchor,
                            paddingLeft: 16,
                            paddingRight: 16)
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.centerY(inView: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers


    // MARK: - Selectors

    @objc func handleLogout() {
        delegate?.handleLogout()
    }
}
