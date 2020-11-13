//
//  NumberButton.swift
//  Sticky Passcode
//
//  Created by Eilon Krauthammer on 11/11/2020.
//

import UIKit

final class NumberButton: UIView {

    typealias TapHandler = (Int) -> Void
    
    private var tapHandler: TapHandler?
    private var number: Int
    private var additionalText: String?
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 80, height: 80.0)
    }
    
    public init(numberData: NumberData, tapHandler: TapHandler?) {
        self.number = numberData.number
        self.additionalText = numberData.additionalText
        self.tapHandler = tapHandler
        super.init(frame: .zero)
        
        configureLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyDesign()
    }
    
    private func applyDesign() {
        clipsToBounds = true
        layer.cornerRadius = bounds.height / 2
    }
    
    private func configureLayout() {
        let numberLabel = UILabel.default(text: "\(number)", color: .white, style: .largeTitle)
        let textLabel = UILabel.default(text: additionalText, color: .white, style: .caption2)
        
        let labels = UIStackView(arrangedSubviews: [numberLabel, textLabel])
        labels.axis = .vertical
        labels.alignment = .center
        labels.isUserInteractionEnabled = false
        
        let button = Button { [unowned self] in
            tapHandler?(number)
        }
        button.fix(in: self)
        
        addSubview(labels)
        labels.center(in: self)
    }
    
    // MARK: - Useless stuff
    
    required init?(coder: NSCoder) {
        fatalError("y u do this")
    }
}

final class Button: UIButton {
    private let action: () -> Void
    
    override public var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = UIColor.white.withAlphaComponent(0.5)
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.backgroundColor = UIColor.white.withAlphaComponent(0.2)
                }
            }
        }
    }
    
    public init(action: @escaping () -> Void) {
        self.action = action
        super.init(frame: .zero)
        backgroundColor = UIColor.white.withAlphaComponent(0.2)
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    @objc private func tapped() { action() }
    
    required init?(coder: NSCoder) {
        fatalError("Please don't initialie me from storyboards :(")
    }
}
