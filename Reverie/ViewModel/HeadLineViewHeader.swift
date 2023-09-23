//
//  HeadLineViewHeader.swift
//  Reverie
//
//  Created by 이예인 on 9/22/23.
//

import UIKit

final class HeadLineViewHeader: UICollectionReusableView {
    // MARK: - Properties
    
    static let id = "HeadLineViewHeaderIdentifier"
    
    var category: String? = "General" {
        didSet { subTitleLabel.text = category }
    }
    
    // MARK: - UI Properties
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "HeadLine"
        $0.font = .roboto(size: 30, bold: .bold)
        $0.sizeToFit()
    }
    
    private lazy var subTitleLabel = UILabel().then {
        $0.text = category
        $0.font = .roboto(size: 24, bold: .semibold)
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
    
    // MARK: - Configures
    
    func configure() {
        backgroundColor = .clear
    }
    
    func configureAutoLayout() {
        let sidePadding = 30
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(sidePadding)
        }
        
        addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(self).offset(sidePadding)
            make.bottom.equalTo(self).offset(-10)
        }
    }
}
