//
//  PostCell.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/23.
//

import UIKit
import Then

protocol NewsPageCellMessageDelegate: AnyObject {
    func showMessage(_ message: String)
}

protocol NewsPageCellOpenDelegate: AnyObject {
    func openNews(news: News)
}

class NewsListView: UIView {
    // MARK: - Properties
    
    private var currentPage: Int = -1
    
    private var isLastPage: Bool = false
    
    private var headline: Bool = true
    
    var currentCategory: String = "General"
    
    weak var messageDelegate: NewsPageCellMessageDelegate?
    
    weak var openNewsDelegate: NewsPageCellOpenDelegate?
    
    // MARK: - Data Source
    
    private var newsList: [News] = [] {
        didSet {
            DispatchQueue.main.async {
                self.newsCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - UI Properties
    
    private lazy var newsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: UIScreen.main.bounds.width - 60, height: 80)
            $0.minimumLineSpacing = 20
            $0.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }
    ).then {
        $0.register(
            NewsListCell.self,
            forCellWithReuseIdentifier: NewsListCell.id
        )
        $0.register(
            CategoryHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CategoryHeader.id
        )
        $0.register(
            HeadLineViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeadLineViewHeader.id
        )
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.delegate = self
    }

    // MARK: - Lifecycle
    
    init(currentCategory: String, containsCategory: Bool) {
        self.currentCategory = currentCategory
        self.headline = containsCategory
        
        super.init(frame: .zero)
        
        configure()
        configureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    
    func configure() {
        backgroundColor = .white
        addFetchNews(category: currentCategory)
    }
    
    func configureAutoLayout() {
        addSubview(newsCollectionView)
        newsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - API

    func addFetchNews(category: String, completion: (() -> Void)? = nil) {
        guard !isLastPage else {
            messageDelegate?.showMessage("더이상 표시할 뉴스가 없어요")
            return
        }
        
        NewsService.fetchNews(page: currentPage + 1, category: category) { newsList in
            if newsList.isEmpty {
                self.isLastPage = true
                return
            }
            self.newsList += newsList.filter{$0.title?.contains("Removed") == false}
            self.currentPage += 1
        }
    }
}

// MARK: - UICollectionViewDataSource

extension NewsListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = newsCollectionView.dequeueReusableCell(
            withReuseIdentifier: NewsListCell.id,
            for: indexPath
        ) as! NewsListCell
        cell.viewModel = NewsListCellViewModel(news: newsList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: headline ? HeadLineViewHeader.id : CategoryHeader.id,
            for: indexPath
        )
        if let header = header as? HeadLineViewHeader {
            header.category = currentCategory
        } else if let header = header as? CategoryHeader {
            header.delegate = self
            header.seletedCategory = currentCategory
        }
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension NewsListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openNewsDelegate?.openNews(news: newsList[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard newsList.count > 1 else { return }
        
        if indexPath.row == newsList.count - 2 {
            addFetchNews(category: currentCategory)
        }
    }
}

// MARK: - CategoryHeaderDelegate

extension NewsListView: CategoryHeaderDelegate {
    func categoryHeader(_ categoryView: CategoryHeader, selectedCategory: String) {
        newsListInit(selectedCategory)
        
        if (selectedCategory == "community") {

            return
        }
        
        addFetchNews(category: selectedCategory) {
            DispatchQueue.main.async {
                guard !self.newsList.isEmpty else {
                    self.messageDelegate?.showMessage("표시할 뉴스가 없어요")
                    return
                }
                self.newsCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
    func newsListInit(_ selectedCategory: String) {
        newsList = []
        currentCategory = selectedCategory
        currentPage = -1
        isLastPage = false
    }
}

// MARK: - UICollectionView Delegate Flow Layout

extension NewsListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let header = headline ? HeadLineViewHeader() : CategoryHeader()
        let size = headline ? header.systemLayoutSizeFitting(
            CGSize(width: UIScreen.main.bounds.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ) : CGSize(width: UIScreen.main.bounds.width, height: 40)
        return size
    }
}
