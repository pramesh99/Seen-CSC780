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
    @State var shouldNavigate: Bool = false
    @State private var path = NavigationPath()
    
    var isLoggedIn: Binding<Bool>
    
    var body: some View {
        NavigationStack (path: $path){
            ZStack{
                SystemColors.backgroundColor
                    .ignoresSafeArea()
                VStack(alignment: .leading){
                    ZStack{
                        VStack(alignment: .leading){
                            Text("Sign in")
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
                        //                        NavigationLink {
                        //                            TitleScreen()
                        //                            } label: {
                        //                                Text("Submit")
                        //                                    .fontWeight(.bold)
                        //                                    .frame(width: 350, height: 60)
                        //                                    .background(isInfoValid() ? SystemColors.accentColor : .gray)
                        //                                    .foregroundColor(.white)
                        //                                    .cornerRadius(10)
                        //
                        //                            }
                        //                            .frame(maxWidth: .infinity, alignment: .center)
                        //                            .simultaneousGesture(TapGesture().onEnded{
                        //                                submitHandler()
                        //                            })
                        //                            .disabled(!isInfoValid())
                        
                        //                        if shouldNavigate {
                        //                            NavigationLink(destination: MainView()) {
                        //                                Text("Submit")
                        //                                    .fontWeight(.bold)
                        //                                    .frame(height: 60)
                        //                                    .background(SystemColors.accentColor)
                        //                                    .foregroundColor(.white)
                        //                                    .cornerRadius(10)
                        //                            }
                        //                            .frame(maxWidth: .infinity, alignment: .center)
                        //                        } else {
                        //                            Button(action: {
                        //                                if isInfoValid() {
                        //                                    shouldNavigate = true
                        //                                }
                        //                                submitHandler()
                        //                                Thread.sleep(forTimeInterval: 0.6)
                        ////                                NavigationLink(destination: MainView())
                        //                            }) {
                        //                                Text("Submit")
                        //                                    .fontWeight(.bold)
                        //                                    .frame(width: 350, height: 60)
                        //                                    .background(isInfoValid() ? SystemColors.accentColor : .gray)
                        //                                    .foregroundColor(.white)
                        //                                    .cornerRadius(10)
                        //                            }
                        //                            .frame(maxWidth: .infinity, alignment: .center)
                        //                            .disabled(!isInfoValid())
                        //                        }
                        
                        Button(action: {
                            submitHandler()
                        }) {
                            Text("Submit")
                                .fontWeight(.bold)
                                .frame(height: 60)
                                .background(isInfoValid() ? SystemColors.accentColor : .gray)
                                .foregroundColor(.white)
                            .cornerRadius(10)}
//                        }.navigationDestination(for: String.self) { view in
//                            if isLoggedIn.wrapped {
//                                MainView()
////                                Text("Stuff")
//                            }
//                        }
                        
                        
                        if EmailNotValid {
                            Text("Email is not Valid. Please check spelling or sign up.").foregroundStyle(.red)
                        }
                        
                        if PwdNotValid {
                            Text("Password is incorrect.").foregroundStyle(.red)
                        }
                        //                        Text("test")
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
        EmailNotValid = false
        PwdNotValid = false
        print("here")
        var docID: String = ""
        var name: String = ""
        var username: String = ""
        print("here2")
        //hash password
        let data = Data(Pwd.utf8)
        let hashed = SHA256.hash(data: data)
        HashPwd = hashed.compactMap {String(format: "%02x", $0)}.joined()
        print("here3")
        let usersCollection = Firestore.firestore().collection("users")
        let snapshot = try await usersCollection.whereField("email", isEqualTo: Email).getDocuments()
        print("here4")
        if !snapshot.documents.isEmpty{
            let doc = snapshot.documents[0].data()
            docID = snapshot.documents[0].documentID
            name = doc["name"] as! String
            username = doc["username"] as! String
            let unwrappedPwd = doc["pwd"] ?? ""
            if !HashPwd.isEqual(unwrappedPwd as! String) {
                PwdNotValid = true
            }
        } else {
            EmailNotValid = true
        }
        print("here5")
        // authenticated
        if !EmailNotValid && !PwdNotValid {
            UserDefaults.standard.set(docID, forKey: "userID")
            UserDefaults.standard.set(name, forKey: "name")
            UserDefaults.standard.set(username, forKey: "username")
            print("AUTHENTICATED")
            shouldNavigate = true
            path.append("MainView")
            isLoggedIn.wrappedValue = true
        }
        
        
    }
}

struct SignIn_Previews: PreviewProvider {
    @State static var isLoggedIn = false
    static var previews: some View {
        SignIn(isLoggedIn: $isLoggedIn)
    }
}
