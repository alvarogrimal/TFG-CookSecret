//
//  BaseCoordinator.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 18/11/23.
//

import Foundation
import Combine

// MARK: BaseCoordinatorProtocol

public protocol BaseCoordinatorProtocol {}

// MARK: BaseCoordinator

open class BaseCoordinator: BaseCoordinatorProtocol, ObservableObject, Identifiable {
    public init() {}
}
