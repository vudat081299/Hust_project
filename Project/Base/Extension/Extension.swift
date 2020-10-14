//
//  Extension.swift
//  Project
//
//  Created by Be More on 9/29/20.
//

import Foundation
import UIKit

extension UIView {
    // MARK: - Programatically constraints

    /// Add constraints programatically.
    ///
    /// - Parameters:
    ///   - top: constraint to top anchor
    ///   - left: constraint to left anchor
    ///   - bottom: constraint to bottom anchor
    ///   - right: constraint to right anchor
    ///   - paddingTop: top padding
    ///   - paddingLeft: left padding
    ///   - paddingBottom: bottom padding
    ///   - paddingRight: right padding
    ///   - width: set width
    ///   - height: set height
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    /// Center to superview
    ///
    /// - Parameters:
    ///   - view: center to view
    ///   - yConstant: set y constraint
    func center(inView view: UIView, xConstant: CGFloat? = 0 , yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: xConstant!).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    /// Center X to superview
    ///
    /// - Parameters:
    ///   - view: superview
    ///   - topAnchor: constraint to top anchor
    ///   - paddingTop: add padding top
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    /// Center Y to superview
    ///
    /// - Parameters:
    ///   - view: superview
    ///   - leftAnchor:  constraint to left anchor
    ///   - paddingLeft:  add padding left
    ///   - constant: constant set to center y anchor
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = nil, constant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true
        
        if let leftAnchor = leftAnchor, let padding = paddingLeft {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }
    
    /// Set view dimensions
    ///
    /// - Parameters:
    ///     - width: set width anchor
    ///     - height: set height anchor
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    /// Set constaint full to superview
    ///
    /// - Parameters:
    ///   - view: superview
    func addConstraintsToFillView(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    /// Constraints by visual format.
    ///
    /// - Parameters:
    ///   - format: format
    ///   - views: constraint in view
    func addVisualFormatConstraint(format: String, views: UIView...) {
        var viewDictionaries = [String: UIView]()
        
        for (key, view) in views.enumerated() {
            let key = "v\(key)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDictionaries[key] = view
        }
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionaries))
    }
}

// MARK: - UIColor
extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let twitterBlue = UIColor.rgb(red: 29, green: 161, blue: 242)
}

