//
//  CommentCell.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/16.
//

import UIKit
import SDWebImage

class CommentCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: CommentViewModel? {
        didSet { configure() }
    }
    
    let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "venom-7")
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "joker"
        label.font = .boldSystemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping // 줄바꿈을 단어 단위로 한다.
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureCell() {
        addSubview(profileImage)
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.leading.equalTo(snp.leading).offset(10)
            make.centerY.equalTo(snp.centerY)
        }
        profileImage.layer.cornerRadius = 40 / 2
        
        addSubview(commentLabel)
        commentLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.centerY.equalTo(self)
            make.trailing.equalTo(snp.trailing).offset(-10)
        }
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        profileImage.sd_setImage(with: viewModel.profileImageURL)
        commentLabel.attributedText = viewModel.commentLabelText
    }
}
