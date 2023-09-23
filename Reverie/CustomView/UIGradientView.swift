//
//  GradientView.swift
//  Reverie
//
//  Created by 이예인 on 9/12/23.
//

import UIKit

class UIGradientView: UIView {

    private let gradient : CAGradientLayer = CAGradientLayer()
    private let gradientColors: [UIColor]
    private let startPoint: CGPoint
    private let endPoint: CGPoint
    private let location: [NSNumber]

    init(gradientColors: [UIColor], startPoint: CGPoint, endPoint: CGPoint, location: [NSNumber]) {
        self.gradientColors = gradientColors
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.location = location
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient.frame = self.bounds
    }

    override public func draw(_ rect: CGRect) {
        gradient.frame = self.bounds
        gradient.colors = gradientColors.map(\.cgColor)
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.locations = location
        if gradient.superlayer == nil {
            layer.insertSublayer(gradient, at: 0)
        }
    }
}
