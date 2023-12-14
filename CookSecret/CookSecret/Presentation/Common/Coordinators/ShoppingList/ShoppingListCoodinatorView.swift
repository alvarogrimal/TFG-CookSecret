//
//  ShoppingListCoodinatorView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 5/12/23.
//

import SwiftUI

struct ShoppingListCoodinatorView: View {
    
    // MARK: - Properties
    
    @StateObject var coordinator: ShoppingListCoodinator
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            shoppingListView()
        }.navigationViewStyle(.stack)
    }
    
    // MARK: - Private functions
    
    @ViewBuilder
    private func shoppingListView() -> some View {
        if let viewModel = coordinator.shoppingListViewModel {
            ShoppingListView(viewModel: viewModel)
                .sheet(isPresented: $coordinator.addIngredientNavigationItem.isActive) {
                    addIngredientView()
                }
                .sheet(isPresented: $coordinator.addFromRecipesNavigationItem.isActive, content: {
                    addFromRecipesView()
                })
        }
    }
    
    @ViewBuilder
    private func addIngredientView() -> some View {
        if let viewModel = coordinator.addIngredientNavigationItem.model {
            NavigationView {
                AddIngredientView(viewModel: viewModel)
            }.navigationViewStyle(.stack)
        }
    }
    
    @ViewBuilder
    private func addFromRecipesView() -> some View {
        if let viewModel = coordinator.addFromRecipesNavigationItem.model {
            NavigationView {
                RecipeListPickerView(viewModel: viewModel)
            }.navigationViewStyle(.stack)
        }
    }
}

#Preview {
    ShoppingListCoodinatorView(coordinator: .sample)
}
