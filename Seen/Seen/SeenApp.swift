//
//  SeenApp.swift
//  Seen
//
//  Created by Preetham Ramesh on 3/18/24.
//

import SwiftUI
import SwiftData
import Firebase

@main
struct MoviApp: App {
    let persistenceController = PersistenceController.shared
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            BrowseView()
                .environment(\.font, Font.inter())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .background(SystemColors.backgroundColor)
                .preferredColorScheme(.dark)
        }
    }
}
