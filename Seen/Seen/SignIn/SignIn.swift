//
//  SignIn.swift
//  Seen
//
//  Created by Preetham Ramesh on 4/30/24.
//

import SwiftUI
import Foundation
import CryptoKit
import Firebase

struct SignIn: View {
    @Environment(\.dismiss) var dismiss
    
    @State var Email: String = ""
    @State var Pwd: String = ""
    @State var HashPwd: String = ""
    @State var EmailNotValid: Bool = false
    @State var PwdNotValid: Bool = false
    
    var body: some View {
            ZStack{
                SystemColors.backgroundColor
                    .ignoresSafeArea()
                VStack(alignment: .leading){
                    ZStack{
                        VStack(alignment: .leading){
                            Text("Sign in")
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
                                if Email.isEmpty {
                                    Text("Email")
                                        .foregroundColor(.white.opacity(0.4))
                                        .font(.system(size: 15))
                                }
                                
                                TextField("", text: $Email)
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .frame(height: 40)
                                    .overlay(RoundedRectangle(cornerRadius: 8.0).strokeBorder(Color.white, style: StrokeStyle(lineWidth: 1.0)).frame(width: 350, height: 60))
                            }
                            .listRowBackground(SystemColors.backgroundColor)
                            
                            ZStack (alignment: .leading){
                                if Pwd.isEmpty {
                                    Text("Password")
                                        .foregroundColor(.white.opacity(0.4))
                                        .font(.system(size: 15))
                                }
                                
                                SecureField("", text: $Pwd)
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .frame(height: 40)
                                    .overlay(RoundedRectangle(cornerRadius: 8.0).strokeBorder(Color.white, style: StrokeStyle(lineWidth: 1.0)).frame(width: 350, height: 60))
                            }
                            .listRowBackground(SystemColors.backgroundColor)
                            .padding(.top, 10)
                        }
                        .textCase(nil)
                    }
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .tint(SystemColors.accentColor)
                    .offset(y:80)
                    
                    VStack{
                        NavigationLink {
//                            ProfileScreen(email: Email, name: Pwd) //CHANGE TARGET
                            } label: {
                                Text("Submit")
                                    .fontWeight(.bold)
                                    .frame(width: 350, height: 60)
                                    .background(isInfoValid() ? SystemColors.accentColor : .gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .simultaneousGesture(TapGesture().onEnded{
                                //dont think i need this
                                submitHandler()
                            })
                            .disabled(!isInfoValid())
                        
                        if EmailNotValid {
                            Text("Email is not Valid. Please check spelling or sign up.").foregroundStyle(.red)
                        }
                        
                        if PwdNotValid {
                            Text("Password is incorrect.").foregroundStyle(.red)
                        }
                        
                        Spacer()
                        
                        
                    }
                    .offset(y:-40)
                }
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
    
    private func isInfoValid() -> Bool {
        return !Email.isEmpty && !Pwd.isEmpty
    }
    
    private func submitHandler(){
        Task {
            do {
                try await authenticate()
            } catch {
                print("Error: \(error)")
            }
            
        }
    }
    
    private func authenticate() async throws -> Void {
        //hash password
        let data = Data(Pwd.utf8)
        let hashed = SHA256.hash(data: data)
        HashPwd = hashed.compactMap {String(format: "%02x", $0)}.joined()
        
        // Cases: email does not exist. Sign up
//                Password is incorrect
        
        let usersCollection = Firestore.firestore().collection("users")
        let snapshot = try await usersCollection.whereField("email", isEqualTo: Email).getDocuments()
        let doc = snapshot.documents[0].data()
        
        if doc["email"] as! String != Email{
            // return Email is not valid, break?
            EmailNotValid = true
        } else if HashPwd.isEqual(doc["pwd"]) {
            // return pwd is incorrect, break?
            PwdNotValid = true
        }
        
        // authenticated
        
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
