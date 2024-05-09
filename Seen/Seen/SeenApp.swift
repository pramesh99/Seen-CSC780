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
struct SeenApp: App {
    // add a state called isLoggedIn
    @State private var isLoggedIn: Bool
    
    let persistenceController = PersistenceController.shared
    
    init() {
        FirebaseApp.configure()
        
        // check for userID in userdefaults and set isLoggedIn
        print("Eval: \(UserDefaults.standard.object(forKey: "userID") != nil)")
        isLoggedIn = UserDefaults.standard.object(forKey: "userID") != nil
        print("\(UserDefaults.standard.object(forKey: "userID") ?? "No userID")")
        print("isLoggedIn: \(isLoggedIn)")
        let defaults = UserDefaults.standard
        let dict = defaults.dictionaryRepresentation()
        
        for (k, v) in dict {
            print("\(k): \(v)")
        }
    }
    
    var body: some Scene {
        
        WindowGroup {
            //if isLoggedIn, go to browseview else go to title page
            if isLoggedIn {
                BrowseView()
                    .environment(\.font, Font.inter())
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .background(SystemColors.backgroundColor)
                    .preferredColorScheme(.dark)
            } else {
                TitleScreen()
            }
        }
    }
}
