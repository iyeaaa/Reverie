//
//  MainThinkCell.swift
//  Reverie
//
//  Created by 이예인 on 9/5/23.
//

import UIKit

class HeadLineThinkCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let id = "HomeThinkCell"
    
    var viewModel: ThinkCellViewModel? {
        didSet { configureByViewModel() }
    }
    
    // MARK: - UI Properties
    
    private let profileimageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.white.cgColor
        $0.backgroundColor = .clear
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
    }
    
    private let userLabel = UILabel().then {
        $0.font = .roboto(size: 20, bold: .bold)
        $0.textColor = .white
        $0.numberOfLines = 1
        $0.sizeToFit()
    }
    
    private let shadowTopView = UIGradientView(
        gradientColors: [.black.withAlphaComponent(0.5), .black.withAlphaComponent(0.3), .clear],
        startPoint: CGPoint(x: 0.5, y: 0.0),
        endPoint: CGPoint(x: 0.5, y: 1.0),
        location: [0, 0.5, 1]
    )
    
    private let shadowBottomView = UIGradientView(
        gradientColors: [.black.withAlphaComponent(0.5), .black.withAlphaComponent(0.3), .clear],
        startPoint: CGPoint(x: 0.5, y: 1.0),
        endPoint: CGPoint(x: 0.5, y: 0.0),
        location: [0, 0.5, 1]
    )
    
    private let contentLabel = UILabel().then {
        $0.font = .roboto(size: 24, bold: .bold)
        $0.textColor = .white
        $0.numberOfLines = 2
        $0.sizeToFit()
    }
    
    private let timeLabel = UILabel().then {
        $0.font = .roboto(size: 11, bold: .bold)
        $0.textColor = .white
        $0.numberOfLines = 2
        $0.sizeToFit()
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure() {
        clipsToBounds = true
        layer.cornerRadius = 25
        shadowTopView.isHidden = true
        shadowBottomView.isHidden = true
    }
    
    func configureAutoLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(profileimageView)
        profileimageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(15)
            make.width.height.equalTo(40)
        }
        
        contentView.addSubview(userLabel)
        userLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileimageView)
            make.leading.equalTo(profileimageView.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualTo(contentView).offset(-10)
        }
        
        imageView.addSubview(shadowTopView)
        shadowTopView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(70)
        }
        
        imageView.addSubview(shadowBottomView)
        shadowBottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(shadowBottomView).inset(15)
            make.trailing.lessThanOrEqualTo(shadowBottomView).inset(15)
            make.bottom.equalTo(shadowBottomView).inset(10)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(shadowBottomView).inset(15)
            make.trailing.lessThanOrEqualTo(shadowBottomView).inset(15)
            make.centerY.equalTo(shadowBottomView)
        }
    }
    
    func configureByViewModel() {
        profileimageView.sd_setImage(with: viewModel?.userProfileImageUrl) { _, _, _, _ in
            self.shadowTopView.isHidden = false
            self.shadowBottomView.isHidden = false
        }
        imageView.sd_setImage(with: viewModel?.imageUrl)
        contentLabel.text = viewModel?.title
        userLabel.text = viewModel?.username
        timeLabel.text = viewModel?.timestampString
    }
}
