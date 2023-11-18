//
//  BaseView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 18/11/23.
//

import Foundation
import SwiftUI

// MARK: BaseView

public struct BaseView: ViewModifier {

    // MARK: - Properties
    
    let viewModel: Any

    // MARK: - View
    
    @MainActor public func body(content: Content) -> some View {
        ZStack(alignment: .center) {}
        .onAppear(perform: {
            guard let viewModel = viewModel as? LifecycleViewProtocol else { return }
            viewModel.onAppear()
            })
        .onDisappear(perform: {
            guard let viewModel = viewModel as? LifecycleViewProtocol else { return }
            viewModel.onDisappear()
        })
        .onLoad(perform: {
            guard let viewModel = viewModel as? LifecycleViewProtocol else { return }
            viewModel.onLoad()
        })
        .onTapGesture {
            //Hide keyboard
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }

    }
}
