//
//  InputTextView.swift
//  InstagramFirestoreTutorial
//
//  Created by yiyein on 2023/08/14.
//

import UIKit
import SnapKit

class InputTextView: UITextView {

    // MARK: - Properties
    
    var placeholderText: String? {
        didSet { placeholderLabel.text = placeholderText }
    }
    
    let placeholderLabel = UILabel().then {
        $0.font = .panton(size: 18, bold: .bold)
        $0.textColor = .lightGray
    }
    
    var placeholderShouldRowCenter = true {
        didSet {
            if placeholderShouldRowCenter {
                placeholderLabel.snp.remakeConstraints { make in
                    make.leading.equalTo(self).offset(8)
                    make.trailing.lessThanOrEqualTo(self).offset(-8)
                    make.centerY.equalTo(self)
                }
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
        configureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    
    func configure() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    func configureAutoLayout() {
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self).offset(8)
        }
    }
    
    // MARK: - Actions
    
    @objc func handleTextDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}

