//
//  CookSecretApp.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 13/11/23.
//

import SwiftUI

@main
struct CookSecretApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
