//
//  HomeCategoryCollectionCell.swift
//  Reverie
//
//  Created by 이예인 on 9/5/23.
//

import UIKit
import Then

protocol HeadLineCategoryTableCellDelegate: AnyObject {
    func openNews(news: News)
    func openNewsList(category: String?)
    func saveViewModelData(viewModel: HomeCategoryTableCellViewModel)
    func updateCurrentPage(viewModel: HomeCategoryTableCellViewModel, page: Int)
}

class HeadLineCategoryTableCell: UIPagingCollectionView {
    // MARK: - Properties
    
    static var id = "HomeCategoryCollectionCell"

    var viewModel: HomeCategoryTableCellViewModel? {
        didSet { configureByViewModel() }
    }
    
    private var newsList = [News]() {
        didSet {
            self.n = newsList.count
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private let itemWidth: CGFloat = UIScreen.main.bounds.width - 60
    private let itemHeight: CGFloat = 80
    private let itemSpacing: CGFloat = 20
    private let inset = 30
    
    override var rowCount: Int {
        return 3
    }
    
    weak var delegate: HeadLineCategoryTableCellDelegate?
    
    // MARK: - UI Properties
    
    private lazy var lineView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    private lazy var categoryLabel = UILabel().then { label in
        label.text = "HeadLine"
        label.font = .roboto(size: 21, bold: .bold)
        label.textAlignment = .left
        label.sizeToFit()
    }
    
    private lazy var viewAllLabel = UIButton().then {
        $0.setTitle("View All", for: .normal)
        $0.setTitleColor(.reverie(2), for: .normal)
        $0.titleLabel?.font = .roboto(size: 16, bold: .semibold)
        $0.titleLabel?.textAlignment = .center
        $0.addTarget(self, action: #selector(didTapViewAllButton), for: .touchUpInside)
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    
    func configure() {
        backgroundColor = .white
        selectionStyle = .none
        
        let _ = collectionView.with {
            $0.backgroundColor = .white
            $0.register(
                NewsListCell.self,
                forCellWithReuseIdentifier: NewsListCell.id
            )
        }
        
        let _ = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).with {
            $0.itemSize = CGSize(width: self.itemWidth, height: self.itemHeight)
            $0.minimumLineSpacing = itemSpacing
            $0.minimumInteritemSpacing = itemSpacing
            $0.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        }
    }
    
    func configureLayout() {
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.top.equalTo(contentView).offset(30)
            make.leading.trailing.equalTo(contentView).inset(30)
        }
        
        contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView).offset(10)
            make.leading.equalTo(contentView).offset(30)
            make.bottom.lessThanOrEqualTo(contentView)
        }
        
        contentView.addSubview(viewAllLabel)
        viewAllLabel.snp.makeConstraints { make in
            make.centerY.equalTo(categoryLabel)
            make.trailing.equalTo(contentView).offset(-30)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(itemHeight*3 + itemSpacing*2)
            make.bottom.equalTo(contentView)
        }
    }
    
    func configureByViewModel() {
        DispatchQueue.main.async {
            self.categoryLabel.text = self.viewModel!.category
        }
        if let newsList = viewModel?.newsList {
            self.newsList = newsList
            return
        }
        NewsService.fetchNews(page: 0, category: viewModel!.category) { newsList in
            self.newsList = newsList
            self.viewModel?.newsList = self.newsList
            self.delegate?.saveViewModelData(viewModel: self.viewModel!)
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapViewAllButton() {
        delegate?.openNewsList(category: categoryLabel.text)
    }
}

// MARK: - Collection DataSource

extension HeadLineCategoryTableCell {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsListCell.id, for: indexPath) as! NewsListCell
        cell.viewModel = NewsListCellViewModel(news: newsList[indexPath.item])
        return cell
    }
}

// MARK: - Collection Delegate

extension HeadLineCategoryTableCell {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.openNews(news: newsList[indexPath.item])
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        super.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        viewModel?.collectionViewPageIndex = calculatePageIndex()
        delegate?.updateCurrentPage(viewModel: viewModel!, page: viewModel!.collectionViewPageIndex)
    }
}
