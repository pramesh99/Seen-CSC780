//
//  EmailScreen.swift
//  Seen
//
//  Created by Preetham Ramesh on 4/29/24.
//

import SwiftUI

struct EmailScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @State var Email: String = ""
    var isLoggedIn: Binding<Bool>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                SystemColors.backgroundColor
                    .ignoresSafeArea()
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        Text("1/4")
                            .opacity(0.4)
                        HStack{
                            Text("Enter your email")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            if Email.count > 0 && !isEmailValid(){
                                Image(systemName: "xmark")
                                    .font(.system(size: 22))
                                    .foregroundColor(.red)
                            } else if isEmailValid() {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 22))
                                    .foregroundColor(.green)
                            }
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.top, 131)
                    .padding(.bottom, 20)
                    
                    HStack{
                        TextField("", text: $Email)
                            .textInputAutocapitalization(.never)
                            .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.white, style: StrokeStyle(lineWidth: 1.0)).frame(width: geometry.size.width-40, height: 60))
                            .frame(width: geometry.size.width-60)
                            .background{
                                ZStack{
                                    HStack{
                                        if Email.isEmpty {
                                            Text("Your email address")
                                                .foregroundColor(.white.opacity(0.4))
                                                .font(.system(size: 15))
                                                .padding(.trailing,200)
                                        }
                                    }
                                }
                            }
                            .padding()
                    }
                    .frame(width: geometry.size.width)
                    
                    
                    NavigationLink {
                        PasswordScreen(email: Email, isLoggedIn: isLoggedIn)
                    } label: {
                        Text("Next")
                            .frame(width: 350, height: 60)
                            .background(isEmailValid() ? SystemColors.accentColor : .gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.top, 20)
                            .padding(.leading,20)
                        
                    }.disabled(!isEmailValid())
                    
                    Spacer()
  
                } // VStack 1
            } // ZStack1
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
    }
    private func isEmailValid() -> Bool {
        if !Email.isEmpty{
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: Email)
        }
        return false
    }
    
    private func submitEmailHandler(){
        print("Email: \(Email) is valid!")
    }
}

struct EmailScreen_Previews: PreviewProvider {
    @State static var isLoggedIn = false
    static var previews: some View {
        return NavigationStack {
            EmailScreen(isLoggedIn: $isLoggedIn)
        }
    }
}

