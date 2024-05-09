//
//  Template.swift
//  Movi
//
//  Created by Preetham Ramesh on 9/27/23.
//

import SwiftUI

struct Template: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            ZStack{
                SystemColors.backgroundColor
                    .ignoresSafeArea()
                VStack{
                    Text("template")
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            
            .navigationBarTitle("Template")
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

struct Template_Previews: PreviewProvider {
    static var previews: some View {
        Template()
    }
}
