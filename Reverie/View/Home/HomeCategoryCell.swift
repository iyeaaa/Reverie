//
//  MainCategoryCell.swift
//  Reverie
//
//  Created by 이예인 on 9/5/23.
//

import UIKit

class HomeCategoryCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let id = "MainCategoryCell"
    
    var viewModel: HomeCategory? {
        didSet { configureByViewModel() }
    }
    
    // MARK: - UI Properties
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    }
    
    private let shadowView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    private let name = UILabel().then {
        $0.font = .panton(size: 13, bold: .bold)
        $0.textColor = .white
        $0.adjustsFontSizeToFitWidth = true
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
        
    }
    
    func configureAutoLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.addSubview(shadowView)
        shadowView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(name.intrinsicContentSize.height + 14)
        }
        
        contentView.addSubview(name)
        name.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).offset(-7)
            make.centerX.equalTo(contentView)
            make.leading.greaterThanOrEqualTo(contentView).offset(10)
            make.trailing.lessThanOrEqualTo(contentView).offset(10)
        }
    }
    
    override func prepareForReuse() {
        shadowView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(name.intrinsicContentSize.height + 14)
        }
    }
    
    func configureByViewModel() {
        imageView.image = viewModel?.image
        name.text = viewModel?.name
    }
}
