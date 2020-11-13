//
//  Array+Ordering.swift
//  Sticky Passcode
//
//  Created by Eilon Krauthammer on 13/11/2020.
//

import Foundation

extension Array where Element: Equatable {
    func reorder(by preferredOrder: [Element]) -> [Element] {
        return self.sorted { a, b -> Bool in
            guard let first = preferredOrder.firstIndex(of: a) else {
                return false
            }

            guard let second = preferredOrder.firstIndex(of: b) else {
                return true
            }

            return first < second
        }
    }
}
