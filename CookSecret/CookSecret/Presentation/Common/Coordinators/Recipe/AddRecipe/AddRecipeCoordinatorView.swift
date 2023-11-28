//
//  AddRecipeCoordinatorView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 27/11/23.
//

import SwiftUI

struct AddRecipeCoordinatorView: View {
    
    // MARK: - Properties
    
    @StateObject var coordinator: AddRecipeCoordinator
    
    // MARK: - Body
        
    var body: some View {
        NavigationView {
            addRecipeView()
        }.navigationViewStyle(.stack)
    }
    
    // MARK: - Private functions
    
    @ViewBuilder
    private func addRecipeView() -> some View {
        if let viewModel = coordinator.addRecipeViewModel {
            AddRecipeView(viewModel: viewModel)
                .navigation(isActive: $coordinator.addIngredientNavigationItem.isActive) {
                    addIngredientView()
                }
        }
    }
    
    @ViewBuilder
    private func addIngredientView() -> some View {
        if let viewModel = coordinator.addIngredientNavigationItem.model {
            AddIngredientView(viewModel: viewModel)
        }
    }
}

#Preview {
    AddRecipeCoordinatorView(coordinator: .init())
}
