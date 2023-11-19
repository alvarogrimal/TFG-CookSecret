//
//  CookSecretApp.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 13/11/23.
//

import SwiftUI

@main
struct CookSecretApp: App {
    
    // MARK: - Properties
        
    @StateObject var tabbarCoordinator: TabbarCoordinator = .init()

    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            TabbarCoordinatorView(coordinator: tabbarCoordinator)
        }
    }
}
