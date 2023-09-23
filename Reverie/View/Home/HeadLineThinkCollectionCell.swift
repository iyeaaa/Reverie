
//
//  HomeThinkCollectionCell.swift
//  Reverie
//
//  Created by 이예인 on 9/5/23.
//

import UIKit

class HeadLineThinkCollectionCell: UIPagingCollectionView {
    // MARK: - Properties
    
    static var id = "HomeThinkCollectionCell"
    
    private var thinks = [Think]() {
        didSet {
            n = thinks.count
            collectionView.reloadData()
        }
    }
    
    private let inset: CGFloat = 30
    
    // MARK: - UI Properties
    
    private lazy var thinkLabel = UILabel().then {
        $0.text = "Thinkings"
        $0.font = .roboto(size: 21, bold: .bold)
        $0.textAlignment = .left
        $0.sizeToFit()
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    
    func configure() {
        selectionStyle = .none
        fetchThinks()
        
        let _ = collectionView.with {
            $0.backgroundColor = .white
            $0.register(
                HeadLineThinkCell.self,
                forCellWithReuseIdentifier: HeadLineThinkCell.id
            )
        }
        
        let _ = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).with {
            $0.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
            $0.minimumLineSpacing = 20
            $0.itemSize = CGSize(width: UIScreen.main.bounds.width - 2*inset, height: 220)
        }
    }
    
    func configureAutoLayout() {
        contentView.addSubview(thinkLabel)
        thinkLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).offset(30)
            make.trailing.bottom.lessThanOrEqualTo(contentView)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(thinkLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(220)
            make.bottom.equalTo(contentView)
        }
    }
    
    // MARK: - APIs
    
    func fetchThinks() {
        ThinkService.fetchThinks { thinks in
            self.n = thinks.count
            self.thinks = thinks
        }
    }
}

// MARK: - Collection DataSource

extension HeadLineThinkCollectionCell {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HeadLineThinkCell.id,
            for: indexPath
        ) as! HeadLineThinkCell
        cell.viewModel = ThinkCellViewModel(think: thinks[indexPath.row])
        cell.prepareForReuse()
        return cell
    }
}

// MARK: - Collection Delegate

extension HeadLineThinkCollectionCell {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
