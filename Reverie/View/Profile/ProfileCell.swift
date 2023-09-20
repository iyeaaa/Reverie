//
//  ProfileCell.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/10.
//

import UIKit
import SDWebImage

class ProfileCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: ThinkCellViewModel? {
        didSet {
            thinkImageView.sd_setImage(with: viewModel?.imageUrl)
        }
    }
    
    private let thinkImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "venom-7")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        addSubview(thinkImageView)
        thinkImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
