//
//  ProgressIndicatorStack.swift
//  Sticky Passcode
//
//  Created by Eilon Krauthammer on 11/11/2020.
//

import UIKit

final class ProgressIndicatorStack: UIView {

    public var fillCount: Int = 0 {
        didSet { update() }
    }
    
    private var stack: UIStackView!
    
    public init() {
        super.init(frame: .zero)
        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }
    
    private func commonSetup() {
        backgroundColor = nil
        
        translatesAutoresizingMaskIntoConstraints = false
        var indicators = [UIView]()
        (0 ..< 4).forEach { _ in
            indicators.append(Indicator())
        }
        
        stack = UIStackView(arrangedSubviews: indicators)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 16.0
        stack.fix(in: self)
    }
    
    private func update() {
        for (index, indicator) in stack.arrangedSubviews.enumerated() {
            (indicator as! Indicator).isFull = (index <= fillCount - 1)
        }
    }
}

fileprivate final class Indicator: UIView {
    private let accentColor = UIColor(red: 0.986, green: 0.681, blue: 0.087, alpha: 1.00)
    
    public var isFull: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.15) {
                self.backgroundColor = self.isFull ? self.accentColor : .clear
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 16.0, height: 16.0)
    }
    
    public init() {
        super.init(frame: .zero)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    private func configure() {
        layer.borderColor = accentColor.cgColor
        layer.borderWidth = 2.0
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
