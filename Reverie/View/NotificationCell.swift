//
//  NotificationCell.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/20.
//

import UIKit

protocol NotificationCellDelegate: AnyObject {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String)
    func cell(_ cell: NotificationCell, wantsToUnFollow uid: String)
    func cell(_ cell: NotificationCell, wantsToViewThink thinkID: String)
}

class NotificationCell: UITableViewCell {
    
    // MARK: - Properties
    
    var viewModel: NotificationCellViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = #imageLiteral(resourceName: "venom-7")
        
        return iv
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "venom"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var thinkImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        /* UIControl의 subclass만 addTarget을 사용할 수 있다. */
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleThinkTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(tapFollowButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Actions
    
    @objc func tapFollowButton() {
        guard let viewModel = viewModel else { return }

        if viewModel.notification.userIsFollowd {
            delegate?.cell(self, wantsToUnFollow: viewModel.notification.uid)
        } else {
            delegate?.cell(self, wantsToFollow: viewModel.notification.uid)
        }
    }
    
    @objc func handleThinkTapped() {
        guard let thinkID = viewModel?.notification.thinkID else { return }
        delegate?.cell(self, wantsToViewThink: thinkID)
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureAutoLayout()
        followButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
    
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        infoLabel.attributedText = viewModel.infomation
        thinkImageView.sd_setImage(with: viewModel.thinkImageURL)
        thinkImageView.isHidden = viewModel.shouldHideThinkImage
        followButton.isHidden = !viewModel.shouldHideThinkImage
        followButton.setTitle(viewModel.followButtonText, for: .normal)
        followButton.backgroundColor = viewModel.followButtonBackgroundColor
        followButton.tintColor = viewModel.followButtonTintColor
    }
    
    func configureAutoLayout() {
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 48, height: 48))
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(12)
        }
        profileImageView.layer.cornerRadius = 24
        
        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.width.equalTo(UIScreen.main.bounds.width - 68 - 96)
        }
        
        contentView.addSubview(followButton)
        followButton.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).offset(-12)
            make.size.equalTo(CGSize(width: 80, height: 32))
        }
        
        contentView.addSubview(thinkImageView)
        thinkImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).offset(-12)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
    }
}
