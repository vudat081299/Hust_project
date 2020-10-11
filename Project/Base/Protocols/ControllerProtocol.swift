//
//  ControllerProtocol.swift
//  Project
//
//  Created by Be More on 10/11/20.
//

import Foundation
import UIKit

protocol ControllerType: class {
    associatedtype ViewModelType: ViewModelProtocol
    /// Configurates controller with specified ViewModelProtocol subclass
    ///
    /// - Parameter viewModel: CPViewModel subclass instance to configure with
    func configure(with viewModel: ViewModelType)
    /// Factory function for view controller instatiation
    ///
    /// - Parameter viewModel: View model object
    /// - Returns: View controller of concrete type
    static func create(with viewModel: ViewModelType) -> UIViewController
}
