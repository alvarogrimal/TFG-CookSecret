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
        }
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
            }
        }
    }
    
    @ViewBuilder
    private func addFromRecipesView() -> some View {
        if let viewModel = coordinator.addFromRecipesNavigationItem.model {
            NavigationView {
                ShoppingListAddFromRecipesView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    ShoppingListCoodinatorView(coordinator: .sample)
}
