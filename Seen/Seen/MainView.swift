//
//  MainView.swift
//  Seen
//
//  Created by Preetham Ramesh on 5/10/24.
//

import SwiftUI

struct MainView: View {
    @Environment(\.dismiss) var dismiss
    @State private var path = NavigationPath()
    var isLoggedIn: Binding<Bool>
    let persistenceController = PersistenceController.shared
    
    init(isLoggedIn: Binding<Bool>) {
        UITabBar.appearance().unselectedItemTintColor = UIColor.white.withAlphaComponent(0.7)
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(SystemColors.backgroundColor)
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
        
        self.isLoggedIn = isLoggedIn
    }
    
    var body: some View {
        NavigationStack(path: $path){
            VStack{//MAINSTACK
                TabView{
                    Feed()
                        .tabItem {
                            Image(systemName: "movieclapper")
                            Text("Rankings")
                        }
                    
                    BrowseView()
                        .environment(\.font, Font.inter())
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .background(SystemColors.backgroundColor)
                        .preferredColorScheme(.dark)
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                    ProfileScreen(isLoggedIn: isLoggedIn)
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                }
            } //MAINSTACK
            .frame(maxHeight: .infinity, alignment: .top)
        }
        
//        .foregroundColor(Color.white)
        
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image("Back")
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    @State static var isLoggedIn = true
    static var previews: some View {
        MainView(isLoggedIn: $isLoggedIn)
    }
}
