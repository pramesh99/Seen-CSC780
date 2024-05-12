//
//  Feed.swift
//  Seen
//
//  Created by Preetham Ramesh on 5/11/24.
//

import SwiftUI
import Firebase

struct Feed: View {
    @Environment(\.dismiss) var dismiss
  
    func fetchData() async {
        do {
            let ratingsCollection = Firestore.firestore().collection("Ratings")
            let snapshot = try await ratingsCollection.whereField("userID", isEqualTo: UserDefaults.standard.string(forKey: "userID") ?? "MuUwlVs578pYzwLSrsjT")
                .order(by: "created", descending: true)
                .getDocuments()
            // create movieDetailsModel array
            for document in snapshot.documents {
                print(document.data())
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                SystemColors.backgroundColor
                    .ignoresSafeArea()
                VStack{ //Mainstack
                    HStack {
                        Text("Feed")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding()
                            .onAppear{
                                Task{
                                    await fetchData()
                                }
                            }
                        Spacer()
                    }
                    
                    ScrollView{
                        VStack{
                            
                        }
                    }
                    
                    Spacer()
                } // Mainstack
                .frame(maxHeight: .infinity, alignment: .leading)
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

struct Feed_Previews: PreviewProvider {
    static var previews: some View {
        Feed()
    }
}
