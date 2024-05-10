//
//  MainView.swift
//  Seen
//
//  Created by Preetham Ramesh on 5/10/24.
//

import SwiftUI

struct MainView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            ZStack{
                SystemColors.backgroundColor
                    .ignoresSafeArea()
                VStack{//MAINSTACK
                    Text("template")
                } //MAINSTACK
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .foregroundColor(Color.white)
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
