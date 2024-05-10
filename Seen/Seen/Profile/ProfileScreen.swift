//
//  Template.swift
//  Movi
//
//  Created by Preetham Ramesh on 9/27/23.
//

import SwiftUI

struct ProfileScreen: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .leading){
                SystemColors.backgroundColor
                    .ignoresSafeArea()
                VStack{ //MAINSTACK
                    HStack{
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.white)
                            .frame(width: 80, height: 80)
                        VStack(alignment: .leading) {
                            Text(UserDefaults.standard.string(forKey: "name") ?? "John Doe")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.leading, 20)
                            
                            Text("@"+"\(UserDefaults.standard.string(forKey: "username") ?? "jdoe")")
                                .foregroundColor(SystemColors.accentColor)
                                .padding(.leading, 20)
                        }
                        Spacer()
                    }.padding(.leading, 30).padding(.top,30)
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("50")
                                .font(.title)
                                .fontWeight(.bold)
                                .opacity(0.9)
                                
                            Text("Movies")
                                .opacity(0.8)
                        }
                        Spacer()
                        VStack {
                            Text("14")
                                .font(.title)
                                .fontWeight(.bold)
                                .opacity(0.9)
                                
                            Text("Followers")
                                .opacity(0.8)
                        }
                        Spacer()
                        VStack {
                            Text("20")
                                .font(.title)
                                .fontWeight(.bold)
                                .opacity(0.9)
                                
                            Text("Following")
                                .opacity(0.8)
                        }
                        Spacer()
                    }.foregroundStyle(.white).padding(20)
                    
                    VStack{
                        Text("Watch List (\(20))").foregroundStyle(.white)
                        Divider().overlay(SystemColors.accentColor).padding(.horizontal, 10).opacity(0.9)
                    }
                    
                    
                    
                    ScrollView {
                        VStack {
                            ForEach(0..<20) { index in
                                Text("Text object \(index+1)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(7)
//                                    .background(Color.gray)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    

                    Spacer()
                } //MAINSTACK
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
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

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
