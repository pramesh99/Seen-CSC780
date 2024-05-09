//
//  NameScreen.swift
//  Seen
//
//  Created by Preetham Ramesh on 4/30/24.
//

import SwiftUI

struct NameScreen: View {
    @Environment(\.dismiss) var dismiss
    
    let email: String
    let pwd: String
    
    @State private var Name: String = ""
    
    var body: some View {
            ZStack{
                SystemColors.backgroundColor
                    .ignoresSafeArea()
                VStack(alignment: .leading){
                    ZStack{
                        VStack(alignment: .leading){
                            Text("3/4")
                                .opacity(0.4)
                            Text("What's your name?")
                                .textInputAutocapitalization(.words)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .offset(y:120)
                        
                        
                    }
                    
                    Form {
                        Section {
                            ZStack (alignment: .leading){
                                if Name.isEmpty {
                                    Text("John Doe")
                                        .foregroundColor(.white.opacity(0.4))
                                        .font(.system(size: 15))
                                }
                                
                                TextField("", text: $Name)
                                    .textInputAutocapitalization(.words)
                                    .disableAutocorrection(true)
                                    .frame(height: 40)
                                    .overlay(RoundedRectangle(cornerRadius: 8.0).strokeBorder(Color.white, style: StrokeStyle(lineWidth: 1.0)).frame(width: 350, height: 60))
                            }
                            .listRowBackground(SystemColors.backgroundColor)
                            
                        }
                        .textCase(nil)
                    }
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .tint(SystemColors.accentColor)
                    .offset(y:80)
                    
                    
                    VStack{
                        NavigationLink {
                            UsernameScreen(email: email, pwd: pwd, name: Name)
                            } label: {
                                Text("Next")
                                    .fontWeight(.bold)
                                    .frame(width: 350, height: 60)
                                    .background(isNameValid() ? SystemColors.accentColor : .gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .simultaneousGesture(TapGesture().onEnded{
                                //dont think i need this
                                submitNameHandler()
                            })
                            .disabled(!isNameValid())
                        
                        Spacer()
                    }
                    .offset(y:-100)
                    
                }
                // REMOVE THIS
                VStack{
                    Text(email)
                    Text(pwd)
                }
                .offset(y:100)
                
            }
            .foregroundColor(Color.white)
        
        .navigationBarBackButtonHidden(true) // Hide the default back button
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
    
    private func isNameValid() -> Bool {
        return !Name.isEmpty
    }
    
    private func submitNameHandler(){
        print("Name: \(Name) is valid!")
    }
}

struct NameScreen_Previews: PreviewProvider {
    static var previews: some View {
        NameScreen(email: "pr123@gmail.com", pwd: "strongpwd")
    }
}

