//
//  MainCoordinator.swift
//  Sticky Passcode
//
//  Created by Eilon Krauthammer on 11/11/2020.
//

import UIKit

class PasscodeCoordinator: Coordinator {
    var navigationController: UINavigationController
    var children = [Coordinator]()
    
    weak var delegate: PasscodeDelegate?
    
    private var code: APIResult? {
        didSet {
            guard let order = code?.order else { return }
            delegate?.configureButtonLayout(withOrder: order)
        }
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Welcome!")
        
        let vc = StickyPasscodeController.instantiate()
        vc.coordinator = self
        vc.viewModel = PasscodeViewModel()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func ready() {
        (navigationController as? MasterNavigationController)?.isLoadingInterfaceRunning = true
        delegate?.getCode()
    }
    
    func didReceiveCode(_ code: APIResult?) {
        (navigationController as? MasterNavigationController)?.isLoadingInterfaceRunning = false
        self.code = code
        
        print("You neeed to log: \(code?.availableDigits ?? [])")
    }
    
    func didSubmitPasscode(_ passcode: [Int]) {
        if let requiredCode = code?.availableDigits {
            if passcode == requiredCode {
                print("Yep.")
                ready()
            } else {
                print("Invalid code. Go away, intruder!")
            }
        } else {
            print("Invalid code result.")
        }
        
        delegate?.resetAll()
    }
}
