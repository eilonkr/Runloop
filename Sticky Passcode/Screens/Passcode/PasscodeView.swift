//
//  PasscodeView.swift
//  Sticky Passcode
//
//  Created by Eilon Krauthammer on 11/11/2020.
//

import UIKit

// MARK: - View Delegate

protocol PasscodeViewDelegate: AnyObject {
    func numberRegistered(_ number: Int)
}

// MARK: - PasscodeView

final class PasscodeView: UIView {
    
    private weak var delegate: PasscodeViewDelegate?
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 20.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    public var buttonOrder = [Int]() {
        didSet {
            configureLayout(buttonOrder: buttonOrder)
        }
    }

    init(delegate: PasscodeViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        backgroundColor = nil
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = nil
    }
    
    /// For storyboard usage.
    public func set(delegate: PasscodeViewDelegate?) {
        self.delegate = delegate
    }
    
    // MARK: - Layout Configuration
    
    public func configureLayout(buttonOrder: [Int]) {
        // Remove all buttons if there are any.
        if mainStack.arrangedSubviews.count > 0 {
            resetButtons()
        }
        
        // Order the buttons
        let allNumbers = NumberData.allNumbers.reorder(by: buttonOrder.map { NumberData(number: $0, additionalText: nil) })
        
        // Create the layout
        var subSequences = [Array<NumberData>.SubSequence]()
        for i in 0 ..< 4 {
            let slice = allNumbers[(i*3) ..< min((i*3)+3, allNumbers.count)]
            subSequences.append(slice)
        }
        
        // Generate the numbers
        for seq in subSequences {
            let buttons = seq.map({ NumberButton(numberData: $0) { [unowned self] number in
                delegate?.numberRegistered(number)
            }})
            
            let subStack = UIStackView(arrangedSubviews: buttons)
            subStack.axis = .horizontal
            subStack.spacing = 20.0
            subStack.alignment = .center
            subStack.distribution = .equalCentering
            mainStack.addArrangedSubview(subStack)
        }
        
        mainStack.arrangedSubviews.forEach { $0.alpha = 0.0 }
        mainStack.fix(in: self)
        UIView.animate(withDuration: 0.2) {
            self.mainStack.arrangedSubviews.forEach { $0.alpha = 1.0 }
        }
    }
    
    private func resetButtons() {
        mainStack.arrangedSubviews.forEach {
            mainStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}

