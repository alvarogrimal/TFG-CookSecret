//
//  BaseViewModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 18/11/23.
//

import Foundation
import Combine
import SwiftUI

private protocol ViewModelDependencies: AnyObject {
    associatedtype Coordinator
    func getCoordinator() -> Coordinator?
}

protocol LifecycleViewProtocol: AnyObject {
    func onAppear()
    func onDisappear()
    func onLoad()
}

// MARK: BaseViewModel

open class BaseViewModel<Coordinator>: ViewModelDependencies, LifecycleViewProtocol {

    // MARK: Properties
    
    open var cancellableSet = Set<AnyCancellable>()
    private var coordinator: BaseCoordinatorProtocol?
    
    // MARK: Init
    
    public init(coordinator: BaseCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    // MARK: ViewModelDependencies protocol
    
    open func getCoordinator() -> Coordinator? {
        return coordinator as? Coordinator
    }
    
    // MARK: LifecycleViewProtocol protocol
    
    open func onAppear() {}
    
    open func onDisappear() {}
    
    open func onLoad() {}
}
