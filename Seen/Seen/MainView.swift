//
//  MainView.swift
//  Seen
//
//  Created by Preetham Ramesh on 5/10/24.
//

import SwiftUI

struct MainView: View {
    @Environment(\.dismiss) var dismiss
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.white.withAlphaComponent(0.7)
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(SystemColors.backgroundColor)
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
    }
    
    var body: some View {
  
            VStack{//MAINSTACK
                TabView{
                    Text("Home Page")
                        .tabItem {
                            Image(systemName: "movieclapper")
                            Text("Rankings")
                        }
                     
                    BrowseView()
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                    ProfileScreen()
                       .tabItem {
                           Image(systemName: "person")
                           Text("Profile")
                       }
                }
            } //MAINSTACK
            .frame(maxHeight: .infinity, alignment: .top)
        
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
    static var previews: some View {
        MainView()
    }
}
