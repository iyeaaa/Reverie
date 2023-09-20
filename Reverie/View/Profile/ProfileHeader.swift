//
//  ProfileHeader.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/10.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate: AnyObject {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User)
}

class ProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    var viewModel: ProfileHeaderViewModel? {
        didSet { configureByViewModel() }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 40
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var thinksLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var followingsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var statStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [thinksLabel, followersLabel, followingsLabel])
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var topDivider: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    private lazy var bottomDivider: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    private let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        return button
    }()
    
    private let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureAutoLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    
    func configure() {
        backgroundColor = .white
        
    }
    
    func configureAutoLayout() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.top.equalTo(self).offset(16)
            make.leading.equalTo(self).offset(12)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.leading.equalTo(self).offset(12)
        }
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.leading.equalTo(self).offset(12)
            make.trailing.equalTo(self).offset(-12)
        }
        
        addSubview(statStack)
        statStack.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalTo(self)
            make.height.equalTo(50)
        }
        
        addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(self)
            make.height.equalTo(50)
        }
        
        addSubview(topDivider)
        topDivider.snp.makeConstraints { make in
            make.top.equalTo(buttonStack.snp.top)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(0.5)
        }
        
        addSubview(bottomDivider)
        bottomDivider.snp.makeConstraints { make in
            make.top.equalTo(buttonStack.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    func configureByViewModel() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.fullname
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        
        editProfileFollowButton.setTitle(viewModel.followButtonText, for: .normal)
        editProfileFollowButton.backgroundColor = viewModel.followButtonBackgroundColor
        editProfileFollowButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
        
        thinksLabel.attributedText = viewModel.numberOfThinks
        followersLabel.attributedText = viewModel.numberOfFollowers
        followingsLabel.attributedText = viewModel.numberOfFollowings
    }


    // MARK: - Actions
    
    @objc func handleEditProfileFollowTapped() {
        guard let viewModel = viewModel else { return }
        delegate?.header(self, didTapActionButtonFor: viewModel.user)
    }
    
}
