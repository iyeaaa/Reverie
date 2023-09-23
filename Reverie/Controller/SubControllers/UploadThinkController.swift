//
//  UploadPostController.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/14.
//

import UIKit
import SnapKit

protocol UploadThinkControllerDelegate: AnyObject {
    func uploadThinkContollerDidDismissed(_ uploadThinkController: UploadThinkController)
}

class UploadThinkController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: UploadThinkControllerDelegate?
    
    private lazy var titleTextView = UITextField().then {
        $0.placeholder = "Title"
        $0.setPlaceholderColor(.lightGray)
        $0.font = .roboto(size: 24, bold: .semibold)
        $0.tintColor = .reverie(2)
    }
    
    private lazy var separator = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    private lazy var captionTextView = UITextViewWithPlaceHolder().then {
        $0.font = .roboto(size: 20, bold: .semibold)
        $0.contentInset.left = -4
        $0.placeholder = "Caption"
        $0.tintColor = .reverie(2)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureAutoLayout()
    }
    
    // MARK: - Configures
    
    func configure() {
        view.backgroundColor = .white
        navigationItem.title = "Write Thinking"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.leftBarButtonItem?.tintColor = .reverie(2)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapDone))
        navigationItem.rightBarButtonItem?.tintColor = .reverie(2)
    }
    
    func configureAutoLayout() {
        view.addSubview(titleTextView)
        titleTextView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        
        view.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(0.7)
        }
        
        view.addSubview(captionTextView)
        captionTextView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapCancel() {
        dismiss(animated: true) {
            self.delegate?.uploadThinkContollerDidDismissed(self)
        }
    }
    
    @objc func didTapDone() {
        showLoader(true)
        
        guard let title = titleTextView.text else {
            showMessage(withTitle: "Fail", message: "제목을 입력하세요")
            return
        }
        
        guard let caption = captionTextView.text else {
            showMessage(withTitle: "Fail", message: "내용을 입력하세요")
            return
        }
        
        let all_Text = "\(title)\(Constant.separateText)\(caption)"
        
//        ThinkService.uploadThink(caption: all_Text, image: selectedImage) { error in
//            self.showLoader(false)
//            
//            if let error = error {
//                print("DEBUG: Failed to upload post with error: \(error.localizedDescription)")
//                return
//            }
//            
//            self.delegate?.contollerDidFinishuploadingThink(self)
//        }
    }
}

