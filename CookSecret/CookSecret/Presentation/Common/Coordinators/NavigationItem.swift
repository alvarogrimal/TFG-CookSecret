//
//  NavigationItem.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 19/11/23.
//

import Foundation

struct NavigationItem<Object> {
    var model: Object?
    var isActive: Bool {
        didSet {
            if !isActive { model = nil }
        }
    }
    
    init(model: Object? = nil, isActive: Bool = false) {
        self.model = model
        self.isActive = isActive
    }
    
    mutating func navigate(to model: Object) {
        self.model = model
        isActive = true
    }
}
