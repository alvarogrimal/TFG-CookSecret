//
//  CalendarCoordinatorView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 5/12/23.
//

import SwiftUI

struct CalendarCoordinatorView: View {
    
    // MARK: - Properties
    
    @StateObject var coordinator: CalendarCoordinator
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            calendarView()
        }
    }
    
    // MARK: - Private functions
    
    @ViewBuilder
    private func calendarView() -> some View {
        if let viewModel = coordinator.calendarViewModel {
            CalendarView(viewModel: viewModel)
                .sheet(isPresented: $coordinator.addRecipesNavigationItem.isActive, content: {
                    addRecipesView()
                })
        }
    }
    
    @ViewBuilder
    private func addRecipesView() -> some View {
        if let viewModel = coordinator.addRecipesNavigationItem.model {
            NavigationView {
                RecipeListPickerView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    CalendarCoordinatorView(coordinator: .sample)
}
