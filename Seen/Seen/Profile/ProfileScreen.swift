//
//  Template.swift
//  Movi
//
//  Created by Preetham Ramesh on 9/27/23.
//

import SwiftUI

struct LogoutConfirmationModal: View {
    @Binding var isModalPresented: Bool
    
    var body: some View {
        ZStack{
            SystemColors.imageBackgroundColor
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Are you sure you want to log out?")
                    .font(.title)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                
                HStack {
                    Spacer()
                    Button("Cancel") {
                        // Dismiss the modal
                        isModalPresented = false
                    }
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                   
                    NavigationLink {
                        TitleScreen()
                    } label: {
                        Text("Log out")
                            .fontWeight(.bold)
                            .frame(height: 60)
                            .frame(maxWidth: 150)
                            .background(SystemColors.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)

                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .simultaneousGesture(TapGesture().onEnded{
                        isModalPresented = false
                        // change to log out handler
//                        submitHandler()
                    })
                
                    Spacer()
                }
                
            }
            .cornerRadius(10)
            .padding()

        }
    }
}

private func logOutHandler() {
    // clear userDefault stuff
    UserDefaults.standard.removeObject(forKey: "userID")
    UserDefaults.standard.removeObject(forKey: "name")
    UserDefaults.standard.removeObject(forKey: "username")
    // add other stuff such as 
}

struct ProfileScreen: View {
    @Environment(\.dismiss) var dismiss
    @State private var isModalPresented = false
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .leading){
                SystemColors.backgroundColor
                    .ignoresSafeArea()
                VStack{ //MAINSTACK
                    HStack {
                        Spacer()
                        Button(action: {
                            isModalPresented = true
                        }) {
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                                .foregroundColor(.red).padding(.horizontal, 20)
                        }
                        
                    }.sheet(isPresented: $isModalPresented, content: {
                        LogoutConfirmationModal(isModalPresented: $isModalPresented)
                            .presentationDetents([.fraction(0.3)])
                    })
                    
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
                            
                            Text("@"+"\(UserDefaults.standard.string(forKey: "username") ?? "jdoe1")")
                                .foregroundColor(SystemColors.accentColor)
                                .padding(.leading, 20)
                        }
                        Spacer()
                    }.padding(.leading, 30)
                    
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
