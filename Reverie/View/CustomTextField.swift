//
//  CustomTextField.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/07.
//

import UIKit

class CustomTextField: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero) // 원점과 크기가 모두 0, 콜스택 추가 발생 막음
        
        let spacer = UIView()
        spacer.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalTo(50)
        }
        
        leftView = spacer
        leftViewMode = .always
        
        borderStyle = .none
        textColor = .white
        keyboardAppearance = .dark
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        setHeight(50)
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: [.foregroundColor: UIColor(white: 1,
                                                                                          alpha: 0.7)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: has not been implemented")
    }
}
