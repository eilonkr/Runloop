//
//  Storyboarded.swift
//  coordinatortest
//
//  Created by Eilon Krauthammer on 30/10/2020.
//

import UIKit

protocol Storyboarded {
    static func instantiate(from storyboardName: String) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(from storyboardName: String = "Main") -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        return storyboard.instantiateViewController(identifier: id) as! Self
    }
}
