//
//  ExploreCoordinatorView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 1/12/23.
//

import SwiftUI

struct ExploreCoordinatorView: View {
    
    // MARK: - Properties
    
    @StateObject var coordinator: ExploreCoordinator
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            exploreView()
        }
    }
    
    // MARK: - Private functions
    
    @ViewBuilder
    private func exploreView() -> some View {
        if let viewModel = coordinator.exploreViewModel {
            ExploreView(viewModel: viewModel)
                .navigation(isActive: $coordinator.exploreRecipeDetailNavigationItem.isActive) {
                    detailRecipe()
                }
        }
    }
    
    @ViewBuilder
    private func detailRecipe() -> some View {
        if let viewModel = coordinator.exploreRecipeDetailNavigationItem.model {
            ExploreRecipeDetailView(viewModel: viewModel)
        }
    }
}

#Preview {
    ExploreCoordinatorView(coordinator: .sample)
}
