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
    @State private var isLoggedIn: Bool
    
    
    let persistenceController = PersistenceController.shared
    
    init() {
        FirebaseApp.configure()
        // check for userID in userdefaults and set isLoggedIn
        isLoggedIn = UserDefaults.standard.object(forKey: "userID") != nil
//        print("\(UserDefaults.standard.object(forKey: "userID") ?? "No userID")")
    }
    
    var body: some Scene {
        WindowGroup {
            //if isLoggedIn, go to feed/browseview else go to title page
            if isLoggedIn {
                MainView(isLoggedIn: $isLoggedIn)
            } else {
                TitleScreen(isLoggedIn: $isLoggedIn)
            }
        }
    }
}
