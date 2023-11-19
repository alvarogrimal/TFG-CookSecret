//
//  RecipeCoordinatorView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 19/11/23.
//

import SwiftUI

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
        if let viewModel = coordinator.viewModel {
            RecipeListView(viewModel: viewModel)
        }
    }
}

#Preview {
    RecipeCoordinatorView(coordinator: .sample)
}
