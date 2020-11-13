//
//  SlickyMockServer.swift
//  Slicky Passcode
//
//  Created by Ma'ayan Zalevas on 29/06/2007.
//  Copyright © 2020 Runloop LTD. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case unknownEndpoint
    case unknownError
    case unknownParams
}

final class SlickyMockServer {
    enum NetworkResult {
        case success
        case failure(error: NetworkError)
    }

    struct Result {
        let code: NetworkResult
        let value: [String : Any]?
    }
    
    private struct Consts {
        static let passcodeDigits = 0...9
        static let possibleCodes = ["1234", "4321"]
    }

    private init() {}

    static func sendApiCall(endpoint: String, params: [String : String], codeCompletion: @escaping ((Result) -> Void), setupCompletion: @escaping ((Result) -> Void)) throws {

        let failBoth = { (result: Result) in
            codeCompletion(result)
            setupCompletion(result)
        }

        guard !endpoint.isEmpty && endpoint == "getPasscodeInternals" else {
            delayExecution {
                failBoth(Result(code: .failure(error: .unknownEndpoint), value: nil))
            }
            return
        }

        guard let username = params["username"], let password = params["password"] else {
            delayExecution {
                failBoth(Result(code: .failure(error: .unknownParams), value: nil))
            }
            return
        }

        if username == "Runloop" && password == "Run!@0p" {
            delayExecution {
                codeCompletion(Result(code: .success, value: ["code": Consts.possibleCodes.randomElement()!]))
            }
            delayExecution {
                setupCompletion(Result(code: .success, value: ["setup": Consts.passcodeDigits.shuffled()]))
            }
        } else {
            delayExecution {
                failBoth(Result(code: .failure(error: .unknownError), value: nil))
            }
        }
    }

    private static func delayExecution(completion: @escaping (() -> Void)) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + Double.random(in: 0..<3)) {
            completion()
        }
    }
}
