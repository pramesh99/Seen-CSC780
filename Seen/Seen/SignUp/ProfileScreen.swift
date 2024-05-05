//
//  ProfileScreen.swift
//  Seen
//
//  Created by Preetham Ramesh on 4/30/24.
//

import SwiftUI

struct ProfileScreen: View {
    var isUsernameValid: Bool = false
    @StateObject private var UsernameValidate = DebounceTextFieldModel()
    
    let email: String
    let pwd: String
    let name: String
    
    var body: some View {
        NavigationStack{
            ZStack{
                SystemColors.backgroundColor
                    .ignoresSafeArea()
                VStack(alignment: .leading){
                    ZStack{
                        VStack(alignment: .leading){
                            Text("4/4")
                                .opacity(0.4)
                            Text("Create your profile")
                                .textInputAutocapitalization(.words)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .offset(y:120)
                        
                        
                    }
                    
                    Form {
                        Section(/*header: (Text("Username").font(.system(size: 16)).fontWeight(.semibold) + Text("*").foregroundColor(.red))*/) {
                            ZStack (alignment: .leading){
                                if UsernameValidate.inputText.isEmpty {
                                    (Text("Enter username") + Text("*").foregroundColor(.red))
                                        .foregroundColor(.white.opacity(0.4))
                                        .font(.system(size: 15))
                                }
                                
                                TextField("", text: $UsernameValidate.inputText)
                                    .frame(height: 40)
                                    .overlay(RoundedRectangle(cornerRadius: 8.0).strokeBorder(Color.white, style: StrokeStyle(lineWidth: 1.0)).frame(width: 350, height: 60)
                                )
                                .onChange(of: UsernameValidate.debouncedText, perform: validateUsername)
                                
                            }
                            .listRowBackground(SystemColors.backgroundColor)
                            
                        }
//                        .headerProminence(.increased)
                        .textCase(nil)
                    }
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .tint(SystemColors.accentColor)
                    .offset(y:80)
                    
                    Text("Test text")
                    
                    VStack{
                        NavigationLink {
//                                Template()
                            } label: {
                                Text("Next")
                                    .fontWeight(.bold)
                                    .frame(width: 350, height: 60)
                                    .background(isUsernameValid ? Color(hex: 0xF04650) : .gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .simultaneousGesture(TapGesture().onEnded{
                                FinishHandler()
                            })
                            .disabled(!isUsernameValid)
                        
                        Spacer()
                    }
                    .offset(y:-100)
                    
                }
                
            }
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
//        .navigationBarItems(leading: CustomBackButton())
    }
    
    private func validateUsername(userName: String) -> Void {
        //check if username has naughty characters swift has cleanser
        // send debounced text to DB
        print("Chceking if username: \(userName) is valid")
        // if valid change isUsernameValid
    }
    
    private func FinishHandler(){
        print("Sending user data to DB. if \(UsernameValidate.debouncedText) is valid.")
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen(email: "pr123@gmail.com", pwd: "strongpwd", name: "P R")
    }
}

