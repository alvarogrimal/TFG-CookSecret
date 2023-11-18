//
//  ViewExtension.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 18/11/23.
//

import Foundation
import SwiftUI

extension View {
    
    // MARK: - BaseView
    
    public func isBaseView(_ viewModel: Any) -> some View {
        return modifier(BaseView(viewModel: viewModel))
    }
    
    // MARK: View navigation
    
    public func navigation<Destination: View>(isActive: Binding<Bool>,
                                              @ViewBuilder destination: () -> Destination) -> some View {
        overlay(
            VStack(spacing: .zero) {
                NavigationLink(
                    destination: isActive.wrappedValue ? destination() : nil,
                    isActive: isActive,
                    label: { EmptyView() }
                )
                .isDetailLink(false)
                NavigationLink(destination: EmptyView(), label: {})
            }
        )
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
          modifier(BaseViewDidLoadModifier(perform: action))
    }
    
    // MARK: Conditions
    
    public func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            return AnyView(content(self))
        } else {
            return AnyView(self)
        }
    }
    
}
