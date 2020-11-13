//
//  ViewController.swift
//  Sticky Passcode
//
//  Created by Eilon Krauthammer on 11/11/2020.
//

import UIKit

protocol PasscodeDelegate: AnyObject {
    func getCode()
    func configureButtonLayout(withOrder order: [Int])
    func resetAll()
}

final class StickyPasscodeController: BaseController<PasscodeCoordinator, PasscodeViewModel> {
    
    @IBOutlet weak var progressIndicatorView: ProgressIndicatorStack!
    @IBOutlet weak var passcodeView: PasscodeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func configureFromViewModel() {
        super.configureFromViewModel()
        viewModel?.passcode.bind { [unowned self] passcode in
            progressIndicatorView.fillCount = passcode.count
            if passcode.count == PasscodeViewModel.maxNumbersInPasscode {
                coordinator?.didSubmitPasscode(passcode)
            }
        }
    }
    
    private func configure() {
        coordinator?.delegate = self
        passcodeView.set(delegate: viewModel, viewModel: viewModel)
        
        coordinator?.ready()
    }
    
    // MARK: - Actions
    
    @IBAction func deleteTapped(_ sender: Any) {
        viewModel?.removeNumber()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        viewModel?.reset()
    }
}

extension StickyPasscodeController: PasscodeDelegate {
    func getCode() {
        viewModel?.getCode { [weak self] result in
            self?.coordinator?.didReceiveCode(result)
        }
    }
    
    func configureButtonLayout(withOrder order: [Int]) {
        passcodeView.configureLayout(buttonOrder: order)
    }
    
    func resetAll() {
        cancelTapped(self)
    }
}

