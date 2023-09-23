//
//  UIPagingCollectionView.swift
//  Reverie
//
//  Created by 이예인 on 9/13/23.
//

import UIKit
import Then

class UIPagingCollectionView: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    var n: Int = 0
    var pageIndexBeforeDragging = 0
    var rowCount: Int { 1 }
    var lastPageIndex: Int { n % rowCount == 0 ? n/rowCount - 1 : n/rowCount }
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then{
            $0.scrollDirection = .horizontal
        }
    ).then {
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc open dynamic func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        n
    }
    
    @objc open dynamic func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
    }
    
    func calculatePageIndex() -> Int {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let offsetX = collectionView.contentOffset.x
        let pageIndex = Int(round(offsetX / (layout.itemSize.width + layout.minimumLineSpacing)))
        let safePageIndex = max(0, min(pageIndex, lastPageIndex))
        return safePageIndex
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pageIndexBeforeDragging = calculatePageIndex()
    }
    
    @objc open dynamic func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        
        let pageIndexAfterDragging = calculatePageIndex()
        
        let isSamePage = pageIndexAfterDragging == pageIndexBeforeDragging
        let isEnoughToVelocityToPrevPage = pageIndexBeforeDragging - 1 >= 0 && velocity.x <= -0.5
        let isEnoughToVelocityToNextPage = pageIndexBeforeDragging + 1 <= lastPageIndex && velocity.x >= 0.5
        let didUseSwipeToSkipCell = isSamePage && (isEnoughToVelocityToPrevPage || isEnoughToVelocityToNextPage)
        
        // 현재 페이지에서 스크롤을 멈췄지만 속도가 빨라서 넘어가는경우
        if didUseSwipeToSkipCell {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = layout.itemSize.width + layout.minimumLineSpacing
            let wantToUpdatePage = pageIndexBeforeDragging + (velocity.x >= 0 ? +1 : -1)
            let wantToUpdateOffsetX = CGFloat(wantToUpdatePage) * cellWidth
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: wantToUpdateOffsetX, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
        } else {
            if velocity.x < 0 && pageIndexBeforeDragging - 1 < 0 { return }
            if velocity.x > 0 && pageIndexBeforeDragging + 1 > lastPageIndex { return }
            let indexPath = IndexPath(item: pageIndexAfterDragging*rowCount, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
