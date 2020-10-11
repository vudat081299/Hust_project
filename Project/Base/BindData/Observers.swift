//
//  Observers.swift
//  Project
//
//  Created by Be More on 10/11/20.
//

import Foundation

class Observable<T> {
    
    typealias Observer = (_ observable: Observable<T>, T) -> ()
    
    private var observers: [Observer]
    
    public var value: T? {
        didSet {
            if let value = value {
                notifyObservers(value)
            }
        }
    }
    
    init(_ value: T? = nil) {
        self.value = value
        observers = []
    }
    
    func bind(observer: @escaping Observer) {
        self.observers.append(observer)
    }
    
    func notifyObservers(_ value: T) {
        self.observers.forEach { [unowned self](observer) in
            observer(self, value)
        }
    }
    
}


class Dynamic<T>: Codable where T : Codable {
    
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    func bind(_ listener: @escaping Listener) {
        self.listener = listener
        self.listener?(value)
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    private enum CodingKeys: CodingKey {
        case value
    }
    
}
