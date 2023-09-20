//
//  FeedCell.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/07.
//

import UIKit
import SDWebImage

protocol ThinkCellDelegate: AnyObject {
    /* FeedCell에 존재하는 Comment 버튼을 눌러서 navigation stack을 쌓으려면
     FeedCell 자체에서 stack에 쌓을게 아니라, FeedController의 viewController에서 실행해야한다. */
    func cell(_ cell: ThinkCell, wantsToShowCommentsFor think: Think)
    
    /* 좋아요 버튼 셀에서 눌러야 하니까.. */
    func cell(_ cell: ThinkCell, didLike think: Think)
    
    func cell(_ cell: ThinkCell, didTapUsername uid: String)
}

class ThinkCell: UICollectionViewCell {
    //MARK: - Porperties
    
    var delegate: ThinkCellDelegate?
    
    var viewModel: ThinkCellViewModel? {
        didSet { configure() }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill // 비율이 깨지더라도 꽉 채워서 넣기
        iv.clipsToBounds = true // 이미지뷰 넘어가는 부분사라지게 하기
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 20
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("venom", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(didTapUsername), for: .touchUpInside)
        
        return button
    }()
    
    private let thinkImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill // 비율이 깨지더라도 꽉 채워서 넣기
        iv.clipsToBounds = true // 이미지뷰 넘어가는 부분사라지게 하기
        iv.isUserInteractionEnabled = true //
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like_unselected"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send2"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var scrapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.text = "좋아요 1,000개"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "exname"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Some test caption for now.."
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private let thinkTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "2 days ago"
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let s = UIStackView(arrangedSubviews: [likeButton,
                                               commentButton,
                                               shareButton])
        s.axis = .horizontal
        s.distribution = .fillEqually
        return s
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Actions
    
    @objc func didTapUsername() {
        guard let uid = viewModel?.think.ownerUid else { return }
        delegate?.cell(self, didTapUsername: uid)
    }
    
    @objc func didTapLikeButton() {
        guard let think = viewModel?.think else { return }
        delegate?.cell(self, didLike: think)
    }
    
    @objc func didTapCommentButton() {
        guard let think = viewModel?.think else { return }
        delegate?.cell(self, wantsToShowCommentsFor: think)
    }
    
    //MARK: - Helpers
    
    func configureActionButtons() {
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
        // scrap 버튼 추가
        let view = UIView()
        addSubview(view)
        view.addSubview(scrapButton)
        view.snp.makeConstraints { make in
            make.top.equalTo(thinkImageView.snp.bottom)
            make.trailing.equalTo(self)
            make.width.equalTo(40)
            make.height.equalTo(50)
        }
        
        scrapButton.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    
    func configureAutoLayout() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.leading.equalTo(self).offset(12)
        }
        
        addSubview(usernameButton)
        usernameButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        addSubview(thinkImageView)
        thinkImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.leading.equalTo(self).offset(8)
            make.trailing.equalTo(self).offset(-8)
            make.height.equalTo(self.snp.width)
        }
        
        configureActionButtons()
        
        addSubview(likesLabel)
        likesLabel.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom)
            make.leading.equalTo(self).offset(8)
        }
        
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(likesLabel.snp.bottom).offset(8)
            make.leading.equalTo(self).offset(8)
        }
        
        addSubview(captionLabel)
        captionLabel.snp.makeConstraints { make in
            make.leading.equalTo(usernameLabel.snp.trailing).offset(5)
            make.centerY.equalTo(usernameLabel)
        }
        
        addSubview(thinkTimeLabel)
        thinkTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(captionLabel.snp.bottom).offset(8)
            make.leading.equalTo(self).offset(8)
        }
    }
    
    func configure() {
        profileImageView.sd_setImage(with: viewModel?.userProfileImageUrl)
        thinkImageView.sd_setImage(with: viewModel?.imageUrl)
        captionLabel.text = viewModel?.title
        usernameButton.setTitle(viewModel?.username, for: .normal)
        usernameLabel.text = viewModel?.username
        likesLabel.text = viewModel?.likesLabelText
        likeButton.setImage(viewModel?.likeButtonImage, for: .normal)
        likeButton.tintColor = viewModel?.likeButtonTintColor
        thinkTimeLabel.text = viewModel?.timestampString
    }
    
    func tapLikeButton() {
        likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
        likeButton.tintColor = .red
        viewModel?.think.like += 1
        likesLabel.text = viewModel?.likesLabelText
    }
    
    func tapUnlikeButton() {
        likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
        likeButton.tintColor = .black
        viewModel?.think.like -= 1
        likesLabel.text = viewModel?.likesLabelText
    }
}
