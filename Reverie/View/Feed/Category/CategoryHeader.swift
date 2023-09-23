//
//  CategoryView.swift
//  Reverie
//
//  Created by 이예인 on 2023/08/24.
//

import UIKit

private let categoryCellIndentifer = "CategoryCell"

protocol CategoryHeaderMessageDelegate: AnyObject {
    func showMessage(_ message: String?)
}

protocol CategoryHeaderDelegate: AnyObject {
    func categoryHeader(_ categoryView: CategoryHeader, selectedCategory: String)
}

class CategoryHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let id = "CategoryHeaderIdentifier"
    
    private let categoryList = ["General",
                                "Business",
                                "Entertainment",
                                "Health",
                                "Science",
                                "Sports",
                                "Technology"]
    
    var seletedCategory: String = "General" {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(
                    at: IndexPath(row: self.categoryList.firstIndex(of: self.seletedCategory)!, section: 0),
                    at: .centeredHorizontally,
                    animated: true
                )
            }
        }
    }
    
    weak var delegate: CategoryHeaderDelegate?
    
    weak var messageDelegate: CategoryHeaderMessageDelegate?
    
    // MARK: - UI Properties
    
    private let basicLine = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    private lazy var collectionView: UICollectionView = {
        let fl = UICollectionViewFlowLayout()
        fl.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: fl)
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: categoryCellIndentifer)
        cv.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
        configureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    
    func configure() {
        
    }
    
    func configureAutoLayout() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    // MARK: - Helpers
    
    func calculateWidth(_ text: String) -> CGFloat {
        return UILabel().then {
            $0.text = text
            $0.font = .roboto(size: 22, bold: .bold)
        }.intrinsicContentSize.width
    }
}

// MARK: - UICollectionViewDataSource

extension CategoryHeader: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellIndentifer, for: indexPath) as! CategoryCell
        cell.viewModel = CategoryCellViewModel(title: categoryList[indexPath.row])
        if seletedCategory == categoryList[indexPath.row] {
            cell.viewModel?.isSelected = true
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CategoryHeader: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryName = categoryList[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
        
        if cell.viewModel?.isSelected == false {
            cell.viewModel?.isSelected = true
            seletedCategory = categoryName
            collectionView.reloadData()
        }
        
        delegate?.categoryHeader(self, selectedCategory: seletedCategory)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CategoryHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = calculateWidth(categoryList[indexPath.row])
        return CGSize(width: width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}
