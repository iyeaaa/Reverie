//
//  UploadPostController.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/14.
//

import UIKit
import SnapKit

protocol UploadThinkControllerDelegate: AnyObject {
    func contollerDidFinishuploadingThink(_ contoller: UploadThinkController)
}

class UploadThinkController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: UploadThinkControllerDelegate?
    
    var selectedImage: UIImage! {
        didSet { setImage() }
    }
    
    private let photoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    private lazy var titleTextView = InputTextView().then {
        $0.placeholderText = "Enter title.."
        $0.font = .panton(size: 18, bold: .semibold)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.placeholderShouldRowCenter = false
    }
    
    private lazy var captionTextView = InputTextView().then {
        $0.placeholderText = "Enter caption.."
        $0.font = .panton(size: 18, bold: .semibold)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.placeholderShouldRowCenter = false
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
        navigationItem.title = "Upload Think"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapDone))
    }
    
    func configureAutoLayout() {
        view.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.size.equalTo(CGSize(width: 180, height: 180))
        }
        
        view.addSubview(titleTextView)
        titleTextView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.leading.equalTo(view.snp.leading).offset(12)
            make.trailing.equalTo(view.snp.trailing).offset(-12)
            make.top.equalTo(photoImageView.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
        
        view.addSubview(captionTextView)
        captionTextView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.leading.equalTo(view.snp.leading).offset(12)
            make.trailing.equalTo(view.snp.trailing).offset(-12)
            make.top.equalTo(titleTextView.snp.bottom).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    // MARK: - Helpers


    func setImage() {
        photoImageView.image = selectedImage
    }
    
    // MARK: - Actions
    
    @objc func didTapCancel() {
        dismiss(animated: true)
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
        
        ThinkService.uploadThink(caption: all_Text, image: selectedImage) { error in
            self.showLoader(false)
            
            if let error = error {
                print("DEBUG: Failed to upload post with error: \(error.localizedDescription)")
                return
            }
            
            self.delegate?.contollerDidFinishuploadingThink(self)
        }
    }
}

