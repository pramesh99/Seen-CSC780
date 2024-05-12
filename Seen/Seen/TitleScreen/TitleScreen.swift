//
//  TitleScreen.swift
//  Seen
//
//  Created by Preetham Ramesh on 4/29/24.
//

import SwiftUI

struct TitleScreen: View {
    @State private var path = NavigationPath()
    var isLoggedIn: Binding<Bool>
    var body: some View {
        NavigationStack(path: $path){
            ZStack{
                SystemColors.backgroundColor
                    .ignoresSafeArea()
                
                VStack{
                    Image("Clapper")
                        .resizable()
                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fit/*@END_MENU_TOKEN@*/)
                        .padding(.all, 50.0)
                        .offset(x: 0, y: -100)
                    Text("Seen")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .offset(x:0, y: -110)
                    
                    
                    NavigationLink {
                        EmailScreen(isLoggedIn: isLoggedIn)
                        } label: {
                            Text("Create Account")
                                .frame(width: 350, height: 60)
                                .background(SystemColors.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                
                        }
                        .offset(y:-100)
              
                        
                    NavigationLink {
                        SignIn(isLoggedIn: isLoggedIn)
                        } label: {
                            Text("I already have an account")
                                .frame(width: 350, height: 60)
                                .background(SystemColors.backgroundColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                        }
                        .offset(y:-100)
                    
//                    Text("\(UserDefaults.standard.string(forKey: "userID") ?? "No userID")").foregroundStyle(.white)
                    
                }
            }
        }
        .navigationTitle("Main View")

        
    }
}

struct TitleScreen_Previews: PreviewProvider {
    @State static var isLoggedIn: Bool = false
    static var previews: some View {
        TitleScreen(isLoggedIn: $isLoggedIn)
    }
}

