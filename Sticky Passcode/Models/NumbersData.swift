//
//  NumbersData.swift
//  Sticky Passcode
//
//  Created by Eilon Krauthammer on 11/11/2020.
//

import Foundation

struct NumberData: Equatable {
    static func == (lhs: NumberData, rhs: NumberData) -> Bool {
        lhs.number == rhs.number
    }
    
    let number: Int
    let additionalText: String?
    
    static let allNumbers = [
        NumberData(number: 1, additionalText: nil),
        NumberData(number: 2, additionalText: "A B C"),
        NumberData(number: 3, additionalText: "D E F"),
        NumberData(number: 4, additionalText: "G H I"),
        NumberData(number: 5, additionalText: "J K L"),
        NumberData(number: 6, additionalText: "M N O"),
        NumberData(number: 7, additionalText: "P Q R S"),
        NumberData(number: 8, additionalText: "T U V"),
        NumberData(number: 9, additionalText: "W X Y Z"),
        NumberData(number: 0, additionalText: nil)
    ]
}

