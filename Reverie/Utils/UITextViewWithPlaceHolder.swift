//
//  UITextViewWithPlaceHolder.swift
//  InstagramFirestoreTutorial
//
//  Created by yiyein on 2023/08/14.
//

import UIKit
import SnapKit

class UITextViewWithPlaceHolder: UITextView {

    // MARK: - Properties
    
    var placeholderColor: UIColor = .lightGray
    
    var placeholder: String? {
        didSet {
            text = placeholder
            textColor = placeholderColor
        }
    }

    // MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITextViewWithPlaceHolder: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textColor == placeholderColor {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = placeholderColor
        }
    }
}
