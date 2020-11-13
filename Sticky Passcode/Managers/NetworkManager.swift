//
//  NetworkManager.swift
//  Sticky Passcode
//
//  Created by Eilon Krauthammer on 12/11/2020.
//

import Foundation

struct NetworkManager {
    enum Endpoints {
        case getPasscode
    
        var path: String {
            switch self {
                case .getPasscode:
                    return "getPasscodeInternals"
            }
        }
    }
    
    enum ParseError: Error {
        case parsingFailed
        case unknown
    }
    
    typealias PasscodeResult = (Result<APIResult, Error>) -> Void
    typealias ServerResult = SlickyMockServer.Result
    
    static func getPasscode(result: @escaping PasscodeResult) {
        let params = [
            "username": "Runloop",
            "password": "Run!@0p"
        ]
    
        DispatchQueue.global(qos: .background).async {
            do {
                let dispatchGroup = DispatchGroup()
                var digitsResult: ServerResult?
                var orderResult: ServerResult?
                
                for _ in 0 ... 1 { dispatchGroup.enter() }
                try SlickyMockServer.sendApiCall(endpoint: Endpoints.getPasscode.path, params: params) { (availableDigitsResult) in
                    digitsResult = availableDigitsResult
                    dispatchGroup.leave()
                } setupCompletion: { (digitsOrderResult) in
                    orderResult = digitsOrderResult
                    dispatchGroup.leave()
                }
                
                dispatchGroup.notify(queue: .main) {
                    parseResults(digitsResult: digitsResult, orderResult: orderResult, closure: result)
                }
            } catch {
                DispatchQueue.main.async {
                    result(.failure(error))
                }
            }
        }
    }
    
    private static func parseResults(digitsResult: ServerResult?, orderResult: ServerResult?, closure: PasscodeResult) {
        do {
            let digits = try parseValue(ofType: String.self, forKey: "code", from: digitsResult)
                .map { Int(String($0))! }
            let order =  try parseValue(ofType: [Int].self, forKey: "setup", from: orderResult)
            let apiResult = APIResult(availableDigits: digits, order: order)
            closure(.success(apiResult))
        } catch {
            closure(.failure(error))
        }
    }
    
    private static func parseValue<T>(ofType _: T.Type, forKey key: String, from serverResult: ServerResult?) throws -> T {
        switch serverResult?.code {
            case .success:
                if let value = serverResult!.value?[key] as? T {
                    return value
                } else {
                    throw ParseError.parsingFailed
                }
            case .failure(error: let error):
                throw error
            default:
                throw ParseError.unknown
        }
    }
}
