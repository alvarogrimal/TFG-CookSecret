//
//  RecipeCoordinatorView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 19/11/23.
//

import SwiftUI
import CloudKit

struct RecipeCoordinatorView: View {
    
    // MARK: - Properties
    
    @StateObject var coordinator: RecipeCoordinator
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            recipeListView()
        }.navigationViewStyle(.stack)
    }
    
    // MARK: - Private functions
    
    @ViewBuilder
    private func recipeListView() -> some View {
        if let viewModel = coordinator.recipeListViewModel {
            RecipeListView(viewModel: viewModel)
                .sheet(isPresented: $coordinator.addRecipeNavigationItem.isActive, content: {
                    addRecipeCoordinatorView()
                })
                .navigation(isActive: $coordinator.recipeDetailItem.isActive) {
                    getRecipeDetailView()
                }
                .navigation(isActive: $coordinator.exploreRecipeDetailItem.isActive) {
                    getExploreRecipeDetailView()
                }
                .sheet(isPresented: $coordinator.filtersItem.isActive, content: {
                    getFiltersView()
                })
        }
    }
    
    @ViewBuilder
    private func addRecipeCoordinatorView() -> some View {
        if let model = coordinator.addRecipeNavigationItem.model {
            AddRecipeCoordinatorView(coordinator: model)
        }
    }
    
    @ViewBuilder
    private func getRecipeDetailView() -> some View {
        if let model = coordinator.recipeDetailItem.model {
            RecipeDetailView(viewModel: model)
                .sheet(isPresented: $coordinator.editRecipeNavigationItem.isActive) {
                    editRecipeView()
                }
                .sheet(isPresented: $coordinator.shareIsPresented) {
                    if let share = coordinator.share,
                       let recipe = coordinator.recipe {
                        // TODO: - SHARE VIEW
                    }
                }
        }
    }
    
    @ViewBuilder
    private func getExploreRecipeDetailView() -> some View {
        if let model = coordinator.exploreRecipeDetailItem.model {
            ExploreRecipeDetailView(viewModel: model)
        }
    }
    
    @ViewBuilder
    private func getFiltersView() -> some View {
        if let model = coordinator.filtersItem.model {
            NavigationView {
                RecipeListFilterView(viewModel: model)
            }
            .navigationViewStyle(.stack)
        }
    }
    
    @ViewBuilder
    private func editRecipeView() -> some View {
        if let model = coordinator.editRecipeNavigationItem.model {
            AddRecipeCoordinatorView(coordinator: model)
        }
    }
}

#Preview {
    RecipeCoordinatorView(coordinator: .sample)
}
