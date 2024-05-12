//
//  UsernameScreen.swift
//  Seen
//
//  Created by Preetham Ramesh on 4/30/24.
//

import SwiftUI
import Firebase

struct UsernameScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @State var isUsernameValid: Bool = false
    @State var isDocumentAdded: Bool = false
    var isLoggedIn: Binding<Bool>

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
                            Text("Create your username")
                                .textInputAutocapitalization(.words)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .offset(y:120)
                    }
                    
                    Form {
                        Section() {
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
                                    .onChange(of: UsernameValidate.debouncedText) { newValue in
                                        Task {
                                            do {
                                                try await validateUsername()
                                            } catch {
                                                print("Error: \(error)")
                                            }
                                        }
                                    }
                            }
                            
                            HStack{
                                if !UsernameValidate.debouncedText.isEmpty && isUsernameValid{
                                    Image(systemName: "checkmark").foregroundColor(.green.opacity(0.8))
                                    Text("Username is available!").foregroundColor(.green.opacity(0.8))
                                } else if !UsernameValidate.debouncedText.isEmpty && !isUsernameValid{
                                    Image(systemName: "xmark").foregroundColor(.red.opacity(0.8))
                                    Text("Username is taken").foregroundColor(.red.opacity(0.8))
                                }
                            }
                        }
                        .listRowBackground(SystemColors.backgroundColor)
                        .textInputAutocapitalization(.never)
                    }
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .tint(SystemColors.accentColor)
                    .offset(y:80)
                    
                    
                    VStack{
                        Button {
                            SubmitHandler()
                        } label: {
                            Text("Submit")
                                .fontWeight(.bold)
                                .frame(width: 350, height: 60)
                                .background(isUsernameValid ? SystemColors.accentColor : .gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }.disabled(!isUsernameValid)

//                        NavigationLink(destination: Text("title screen"), isActive: $isDocumentAdded){ // CHANGE DESTINATION
//                            
//                            Text("Submit")
//                                .fontWeight(.bold)
//                                .frame(width: 350, height: 60)
//                                .background(isUsernameValid ? SystemColors.accentColor : .gray)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                            
//                        }
//                            .frame(maxWidth: .infinity, alignment: .center)
//                            .offset(y:-10)
//                            .simultaneousGesture(TapGesture().onEnded{
//                                SubmitHandler()
//                            })
//                            .disabled(!isUsernameValid)
                        
                        Spacer()
                    }
                    .offset(y:-80)
                    
                }
                
            }
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity, alignment: .top)
        }
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
    
    private func validateUsername() async throws -> Void {
        if UsernameValidate.debouncedText != "" {
            let usersCollection = Firestore.firestore().collection("users")
            let snapshot = try await usersCollection.whereField("username", isEqualTo: UsernameValidate.debouncedText).getDocuments()
            isUsernameValid = snapshot.documents.isEmpty
        } else {
            isUsernameValid = false
        }
    }
    
    private func SubmitHandler() -> Void {
        print("Sending user data to DB. if \(UsernameValidate.debouncedText) is valid.")
        addDocument()
        if isDocumentAdded {
            isLoggedIn.wrappedValue = true
        }
    }
    
    private func addDocument() -> Void {
        let usersCollection = Firestore.firestore().collection("users")
        let userData: [String: Any] = [
            "name": name,
            "email": email,
            "pwd": pwd,
            "username": UsernameValidate.debouncedText
        ]
        
        var docID: DocumentReference? = nil
        docID = usersCollection.addDocument(data: userData) { error in
            if let error = error {
                // display error message
                print("Error: \(error)")
            } else {
                isDocumentAdded = true
                if let userID = docID?.documentID {
                    print("\(userID)")
                    UserDefaults.standard.set(userID, forKey: "userID")
                    UserDefaults.standard.set(name, forKey: "name")
                    UserDefaults.standard.set(UsernameValidate.debouncedText, forKey: "username")
                    let d: [String: Double] = [:]
                    UserDefaults.standard.set(d, forKey: "cachedRatings")
                    isLoggedIn.wrappedValue = true
                } else {
                    print("No document ID")
                }
                
            }
        }
    }
}

struct UsernameScreen_Previews: PreviewProvider {
    @State static var isLoggedIn = false
    static var previews: some View {
        UsernameScreen(isLoggedIn: $isLoggedIn, email: "pr123@gmail.com", pwd: "strongpwd", name: "P R")
    }
}

