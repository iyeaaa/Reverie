//
//  Extensions.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/07.
//

import UIKit
import JGProgressHUD

extension UIFont {
    static func gangwon(size: CGFloat, bold: Bool = false) -> UIFont? {
        UIFont(name: bold ? "GangwonEduAll-OTFBold" : "GangwonEduAll-OTFLight", size: size)
    }
    
    enum PantonWeight: Int {
        case regular = 0
        case semibold = 1
        case bold = 2
    }
    
    static func panton(size: CGFloat, bold: PantonWeight) -> UIFont? {
        switch bold {
        case .regular: UIFont(name: "Panton-Trial-Regular", size: size)
        case .semibold: UIFont(name: "Panton-Trial-SemiBold", size: size)
        case .bold: UIFont(name: "Panton-Trial-Bold", size: size)
        }
    }
}

extension UITextField {
    func setPlaceholderColor(_ placeholderColor: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: placeholderColor,
                .font: font
            ].compactMapValues { $0 }
        )
    }
}

extension String {
    func subString(from: Int, to: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex..<endIndex])
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static var reverie: (Int) -> UIColor = { level in
        switch level {
        case 0: UIColor(r: 151, g: 254, b: 237)
        case 1: UIColor(r: 53, g: 162, b: 159)
        case 2: UIColor(r: 11, g: 102, b: 106)
        default: UIColor(r: 7, g: 25, b: 82)
        }
    }
}

extension Bundle {
    var apiKey: String {
        guard let file = path(forResource: "NewApiInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["API_KEY"] as? String else { fatalError("API 설정 다시") }
        return key
    }
}

extension UIViewController {
    static let hub = JGProgressHUD(style: .dark)
    
    func configureGradientLayer() {
        // 배경 그라데이션 추가
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame // 시작 좌표와, width height가 같도록 설정
    }
    
    func showLoader(_ show: Bool) {
        view.endEditing(true)
        
        if show {
            UIViewController.hub.show(in: view)
        } else {
            UIViewController.hub.dismiss()
        }
    }
    
    func showMessage(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

extension UIButton {
    func attributedTitle(firstPart: String, secondPart: String) {
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.7), .font: UIFont.systemFont(ofSize: 16)]
        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.boldSystemFont(ofSize: 16)]
        
        let attributedTitle = NSMutableAttributedString(string: "\(firstPart) ", attributes: atts)
        attributedTitle.append(NSAttributedString(string: secondPart, attributes: boldAtts))
        
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
}

extension UIView {
    
    var safeLayoutTopHeight: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.safeAreaInsets.top ?? 0
    }
    
    
    func setHeight(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}
