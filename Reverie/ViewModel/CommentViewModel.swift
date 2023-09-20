//
//  CommentViewMOdel.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/18.
//

import UIKit

struct CommentViewModel {
    
    private let comment: Comment
    
    var profileImageURL: URL? { URL(string: comment.ownerImageURL) }
    
    var commentLabelText: NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(comment.ownerUserName) ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: comment.commentText, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        return attributedString
    }
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    func calculateHeight(forWidth width: CGFloat) -> CGFloat {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.text = comment.commentText
        label.lineBreakMode = .byWordWrapping
        label.font = .boldSystemFont(ofSize: 14)
        label.snp.makeConstraints{ $0.width.equalTo(width) }
        
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    }
}
