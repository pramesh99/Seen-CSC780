//
//  PasswordScreen.swift
//  Seen
//
//  Created by Preetham Ramesh on 4/29/24.
//

import SwiftUI
import CryptoKit

struct PasswordScreen: View {
    @Environment(\.dismiss) var dismiss
    
    let email: String
    
    @State private var Pwd: String = ""
    @State private var HashPwd: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                SystemColors.backgroundColor
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 0){
                    VStack(alignment: .leading){
                        Text("2/4")
                            .opacity(0.4)
                        Text("Create a password")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.top, 120)


                    
                    Form {
                        Section {
                            ZStack (alignment: .leading){
                                if Pwd.isEmpty {
                                    Text("Enter password")
                                        .foregroundColor(.white.opacity(0.4))
                                        .font(.system(size: 15))
                                }
                                
                                SecureField("", text: $Pwd)
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
                    .offset(y:-10)
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 3){
                        HStack{
                            Image(systemName: "checkmark")
                            Text("At least 8 characters")
                            
                        }.foregroundColor(isPwdLong() ? .green.opacity(0.8) : .white.opacity(0.4))
                        HStack{
                            Image(systemName: "checkmark")
                            Text("Includes capital letter(s)")
                            
                        }.foregroundColor(hasCapLetter() ? .green.opacity(0.8) : .white.opacity(0.4))
                        HStack{
                            Image(systemName: "checkmark")
                            Text("Includes number(s)")
                            
                            
                        }.foregroundColor(hasNum() ? .green.opacity(0.8) : .white.opacity(0.4))
                        
                    }
                    .font(.system(size: 13))
                    .padding(.leading,24)
                    .offset(y:-150)
                    
                    VStack{
                        NavigationLink {
                            NameScreen(email: email, pwd: HashPwd)
                        } label: {
                            Text("Next")
                                .fontWeight(.bold)
                                .frame(width: 350, height: 60)
                                .background(isPwdValid() ? SystemColors.accentColor : .gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .simultaneousGesture(TapGesture().onEnded{
                            submitPwdHandler()
                        })
                        .disabled(!isPwdValid())
                        
                        Spacer()
                    }
                    .offset(y:-130)
                }
                
//                Text(email)
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
    }
    
    private func isPwdLong() -> Bool {
        return Pwd.count >= 8
    }
    
    private func hasNum() -> Bool {
        let numRange = Pwd.rangeOfCharacter(from: .decimalDigits)
        return numRange != nil
    }
    
    private func hasCapLetter() -> Bool {
        for char in Pwd {
            if char.isUppercase {
                return true
            }
        }
        return false
    }
    
    private func isPwdValid() -> Bool {
        return isPwdLong() && hasNum() && hasCapLetter()
    }
    
    private func submitPwdHandler(){
        // hash password and set it to state
        let data = Data(Pwd.utf8)
        let hashed = SHA256.hash(data: data)
        HashPwd = hashed.compactMap {String(format: "%02x", $0)}.joined()
    }
}

struct PasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        PasswordScreen(email: "pr123@gmail.com")
    }
}
