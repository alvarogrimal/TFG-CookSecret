//
//  TabbarCoordinatorView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 19/11/23.
//

import SwiftUI

struct TabbarCoordinatorView: View {

    // MARK: - Properties
    
    @StateObject var coordinator: TabbarCoordinator
    
    // MARK: - Body
    
    var body: some View {
        TabView {
            RecipeCoordinatorView(coordinator: coordinator.recipeCoordinator)
                .tabItem {
                    Image.recipe
                }
            
            Text("Tab 2")
                .tabItem {
                    Image.search
                }
            
            Text("Tab 3")
                .tabItem {
                    Image.list
                }
            
            Text("Tab 4")
                .tabItem {
                    Image.calendar
                }
        }.accentColor(.persianBlue)
    }
}

#Preview {
    TabbarCoordinatorView(coordinator: TabbarCoordinator.sample)
}
