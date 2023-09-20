//
//  CommentInputAccesoryView.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/17.
//

import UIKit

protocol CommentInputAccessoryViewDelegate: AnyObject {
    
    /* 왜 이 파라미터들을 전달하려 했는지 생각해보자 */
    func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String)
}

class CommentInputAccessoryView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CommentInputAccessoryViewDelegate?
    
    private lazy var commentTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "Enter comment.."
        tv.font = .systemFont(ofSize: 15)
        tv.isScrollEnabled = false // false면 textView의 크기를 따로 지정하지 않았을 때 커서의 크기로 textView의 height가 자동지정된다.
        return tv
    }()
    
    private lazy var thinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Actions
    
    @objc func didTapPostButton() {
        delegate?.inputView(self, wantsToUploadComment: commentTextView.text)
        clearText()
    }
    
    // MARK: - Helpers
    
    func clearText() {
        commentTextView.text = ""
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        addSubview(thinkButton)
        thinkButton.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.trailing.equalTo(snp.trailing).offset(-8)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        addSubview(commentTextView)
        commentTextView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(8)
            make.top.equalTo(snp.top).offset(8)
            make.trailing.equalTo(thinkButton.snp.leading).offset(8)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
        
        let divider = UIView()
        divider.backgroundColor = .systemGroupedBackground // 뭐냐이건
        addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(snp.top)
            make.leading.equalTo(snp.leading)
            make.trailing.equalTo(snp.trailing)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
}
