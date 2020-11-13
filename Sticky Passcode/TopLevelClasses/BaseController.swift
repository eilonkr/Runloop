//
//  BaseController.swift
//  AppIconMaker
//
//  Created by Eilon Krauthammer on 06/11/2020.
//

import UIKit

class BaseController<CoordinatorType: Coordinator, ViewModelType: AnyObject>: UIViewController, Storyboarded, Coordinated {
    
    typealias T = CoordinatorType
    
    var coordinator: T?
    var viewModel: ViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFromViewModel()
    }
    
    internal func configureFromViewModel() {
        
    }
}

