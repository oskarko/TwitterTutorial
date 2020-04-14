//
//  UserCell.swift
//  TwitterTutorial
//
//  Created by Oscar Rodriguez Garrucho on 14/04/2020.
//  Copyright © 2020 Oscar Rodriguez Garrucho. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    // MARK: - Properties
    
    var user: User? {
        didSet { configureUI() }
    }
    
    private lazy var profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40 / 2
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
         label.font = UIFont.boldSystemFont(ofSize: 14)
         return label
     }()
    
    private let fullnameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let user = user else { return }
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        usernameLabel.text = user.username
        fullnameLabel.text = user.fullname
    }
}
