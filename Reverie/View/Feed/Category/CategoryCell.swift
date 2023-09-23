//
//  CategoryCell.swift
//  Reverie
//
//  Created by 이예인 on 2023/08/24.
//

import UIKit
import Then

class CategoryCell: UICollectionViewCell {
    
    var viewModel: CategoryCellViewModel? {
        didSet { configureByViewModel() }
    }
    
    private var titleLabel = UILabel().then {
        $0.font = .roboto(size: 22, bold: .bold)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.sizeToFit()
    }
    
    private lazy var selectLine = UIView()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        configureByViewModel()
    }
    
    // MARK: - Configures
    
    func configure() {
        
    }
    
    func configureAutoLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
        }
        
        contentView.addSubview(selectLine)
        selectLine.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.height.equalTo(4)
            make.centerX.equalTo(titleLabel)
            make.width.equalTo(self)
        }
    }
    
    func configureByViewModel() {
        titleLabel.text = viewModel?.title
        titleLabel.textColor = viewModel?.textColor
        selectLine.backgroundColor = viewModel?.isSelected == false ? .reverie(1).withAlphaComponent(0.5) : .reverie(2)
    }
    
    // MARK: - Helpers
    
    func calculateWidth(_ text: String) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        return label.frame.width
    }
}
