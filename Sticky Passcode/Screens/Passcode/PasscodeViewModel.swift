//
//  PasscodeViewModel.swift
//  Sticky Passcode
//
//  Created by Eilon Krauthammer on 11/11/2020.
//

import Foundation

final class PasscodeViewModel {
    
    static let maxNumbersInPasscode = 4
    
    public var passcode = Binding<[Int]>([])
    
    public func removeNumber() {
        guard !passcode.value.isEmpty else { return }
        passcode.value.removeLast()
    }
    
    public func reset() {
        guard !passcode.value.isEmpty else { return }
        passcode.value.removeAll()
    }
}

// MARK: - PasscodeViewDelegate

extension PasscodeViewModel: PasscodeViewDelegate {
    func numberRegistered(_ number: Int) {
        guard passcode.value.count < Self.maxNumbersInPasscode else { return }
        passcode.value.append(number)
    }
}

// MARK: - Networking

extension PasscodeViewModel {
    public func getCode(completion: ((APIResult?) -> Void)? = .none) {
        NetworkManager.getPasscode { result in
            switch result {
                case .success(let result):
                    completion?(result)
                case .failure(let error):
                    print(error)
                    completion?(nil)
            }
        }
    }
}

