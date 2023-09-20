//
//  ResetPasswordController.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/21.
//

import UIKit

protocol ResetPasswordControllerDelegate: AnyObject {
    func contollerDidSendResetPasswordLink(_ contoroller: ResetPasswordController)
}

class ResetPasswordController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private var viewModel = ResetPasswordViewModel()
    
    weak var delegate: ResetPasswordControllerDelegate?
    
    var email: String?
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Instagram_logo_white")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Password", for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleShowResetPassword), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private lazy var textFieldStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [emailTextField, resetPasswordButton])
        sv.axis = .vertical
        sv.spacing = 20
        return sv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Actions
    
    @objc func textDidChange(sender: UITextField) {
        viewModel.email = sender.text
        updateForm()
    }
    
    @objc func handleShowResetPassword() {
        guard let email = emailTextField.text else { return }
        
        showLoader(true)
        AuthService.resetPassword(withEmail: email) { error in
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                self.showLoader(false)
                return
            }
            self.delegate?.contollerDidSendResetPasswordLink(self)
        }
    }
    
    @objc func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        emailTextField.text = email
        viewModel.email = email
        updateForm()
        configureGradientLayer()
        configureAutoLayout()
    }
    
    func configureAutoLayout() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        view.addSubview(iconImage)
        iconImage.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 120, height: 80))
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
        }
        
        view.addSubview(textFieldStack)
        textFieldStack.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(32)
            make.left.equalTo(view).offset(32)
            make.right.equalTo(view).offset(-32)
        }
    }
}

extension ResetPasswordController: FormViewModel {
    func updateForm() {
        resetPasswordButton.isEnabled = viewModel.formIsValid
        resetPasswordButton.backgroundColor = viewModel.buttonBackgroundColor
        resetPasswordButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
    }
}
