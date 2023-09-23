//
//  FeedCell2.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/24.
//

import UIKit
import Then

class NewsListCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let id = "NewsListCellIdentifier"
    
    var viewModel: NewsListCellViewModel? {
        didSet { configureByViewModel() }
    }
    
    // MARK: - UI Porperties
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .roboto(size: 16, bold: .semibold)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    private let thinkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill // 비율이 깨지더라도 꽉 채워서 넣기
        $0.clipsToBounds = true // 이미지뷰 넘어가는 부분사라지게 하기
        $0.isUserInteractionEnabled = true //
        $0.layer.cornerRadius = 13
    }

    private let captionLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.roboto(size: 14, bold: .regular)
        $0.numberOfLines = 0
        $0.textColor = .black
    }

    private let clockImage = UIImageView().then {
        $0.image = UIImage(systemName: "clock")
        $0.tintColor = .darkGray
    }
    
    private let thinkTimeLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 12)
        $0.textColor = .black
        $0.sizeToFit()
    }
    
    private let companyImage = UIImageView().then {
        $0.image = UIImage(systemName: "square.and.pencil.circle")
        $0.tintColor = .darkGray
    }
    
    private let companyLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 12)
        $0.textColor = .black
        $0.sizeToFit()
    }
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        autoLayoutDebugCode()
        configure()
        configureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure() {
        backgroundColor = .white
    }
    
    func configureAutoLayout() {
        let commonPadding = 0
        
        addSubview(thinkImageView)
        thinkImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(commonPadding)
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(thinkImageView.snp.trailing).offset(20)
            make.trailing.equalTo(self).offset(-commonPadding)
            make.top.equalTo(thinkImageView)
            make.height.lessThanOrEqualTo(60)
        }
        
        addSubview(clockImage)
        clockImage.snp.makeConstraints { make in
            make.width.height.equalTo(14)
            make.leading.equalTo(thinkImageView.snp.trailing).offset(20)
            make.bottom.equalTo(thinkImageView)
        }
        
        addSubview(thinkTimeLabel)
        thinkTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(clockImage.snp.trailing).offset(4)
            make.bottom.equalTo(thinkImageView)
        }
        
        addSubview(companyImage)
        companyImage.snp.makeConstraints { make in
            make.width.height.equalTo(14)
            make.leading.equalTo(thinkTimeLabel.snp.trailing).offset(20)
            make.bottom.equalTo(thinkImageView)
        }
        
        addSubview(companyLabel)
        companyLabel.snp.makeConstraints { make in
            make.leading.equalTo(companyImage.snp.trailing).offset(4)
            make.bottom.equalTo(thinkImageView)
            make.trailing.lessThanOrEqualTo(self)
        }
    }
    
    func configureByViewModel() {
        guard let viewModel = viewModel else {
            return print("NewsCell의 ViewModel이 설정되지 않았어요.")
        }
        if let newsImageURL = viewModel.newsImageURL {
            thinkImageView.sd_setImage(with: newsImageURL)
        } else {
            thinkImageView.image = UIImage(named: "no_image")
        }
        titleLabel.text = viewModel.title
        captionLabel.text = viewModel.description
        thinkTimeLabel.text = viewModel.date
        companyLabel.text = viewModel.company
    }
    
    func autoLayoutDebugCode() {
        titleLabel.layer.borderWidth = 1
        captionLabel.layer.borderWidth = 1
        thinkTimeLabel.layer.borderWidth = 1
    }

}
