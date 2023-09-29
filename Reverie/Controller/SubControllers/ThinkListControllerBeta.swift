//
//  ThinkListControllerBeta.swift
//  Reverie
//
//  Created by 이예인 on 9/21/23.
//

import UIKit
import SnapKit
import Then

class ThinkListControllerBeta: UIViewController {
    
    // MARK: - Properties
    // MARK: - UI Properties
    
    private lazy var writeButton = WriteButton().then {
        $0.addTarget(self, action: #selector(didTapWriteButton), for: .touchUpInside)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureAutoLayout()
    }
    
    // MARK: - Configures
    
    func configure() {
        
    }
    
    func configureAutoLayout() {
        view.addSubview(writeButton)
        writeButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.width.equalTo(120)
            make.height.equalTo(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapWriteButton() {
        let controller = UINavigationController(
            rootViewController: UploadThinkController().then {
                $0.delegate = self
            }
        )
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
}

// MARK: - Upload Think Contoller Delegate

extension ThinkListControllerBeta: UploadThinkControllerDelegate {
    func uploadThinkContollerDidDismissed(_ uploadThinkController: UploadThinkController) {
        tabBarController?.tabBar.isHidden = false
    }
}


// MARK: - Write Button

private class WriteButton: UIButton {
    private lazy var penImage = UIImageView().then {
        $0.image = UIImage(systemName: "pencil.and.outline")
        $0.tintColor = .reverie(2)
        $0.isUserInteractionEnabled = false
    }
    private lazy var textLabel = UILabel().then {
        $0.text = "Write"
        $0.textColor = .reverie(3)
        $0.font = .roboto(size: 20, bold: .bold)
        $0.sizeToFit()
        $0.isUserInteractionEnabled = false
    }
    private lazy var stackView = UIStackView(arrangedSubviews: [
        penImage, textLabel
    ]).then {
        $0.spacing = 10
        $0.axis = .horizontal
        $0.alignment = .lastBaseline
        $0.isUserInteractionEnabled = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
        configureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 20
        layer.borderColor = UIColor.lightGray.cgColor
        clipsToBounds = true
    }
    
    func configureAutoLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            backgroundColor = isHighlighted ? .systemGray3 : .systemGray6
        }
    }
}
