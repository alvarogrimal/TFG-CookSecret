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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var tabbarCoordinator: TabbarCoordinator = .init()

    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            TabbarCoordinatorView(coordinator: tabbarCoordinator)
                .tint(.black)
        }
    }
}
