//
//  TitleScreen.swift
//  Seen
//
//  Created by Preetham Ramesh on 4/29/24.
//

import SwiftUI

// set app colors to environment colors
extension Color {
    init(hex: UInt) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

struct TitleScreen: View {
    var body: some View {
        NavigationStack{
            ZStack{
                SystemColors.backgroundColor
                    .ignoresSafeArea()
                
                VStack{
                    Image("Clapper")
                        .resizable()
                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fit/*@END_MENU_TOKEN@*/)
                        .padding(.all, 50.0)
                        .offset(x: 0, y: -100)
                    Text("Seen")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .offset(x:0, y: -110)
                    
                    
                    NavigationLink {
                        EmailScreen()
                        } label: {
                            Text("Create Account")
                                .frame(width: 350, height: 60)
                                .background(SystemColors.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                
                        }
                        .offset(y:-100)
              
                        
                    NavigationLink {
                            SignIn()
                        } label: {
                            Text("I already have an account")
                                .frame(width: 350, height: 60)
                                .background(SystemColors.backgroundColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                        }
                        .offset(y:-100)
                    
                }
            }
        }
        .navigationTitle("Main View")

        
    }
}

//struct CustomBackButton: View {
//    @Environment(\.presentationMode) var presentationMode
//
//    var body: some View {
//        Button(action: {
//            self.presentationMode.wrappedValue.dismiss()
//        }) {
//            Image(systemName: "chevron.backward")
//                .imageScale(.large)
//                .foregroundColor(.white)
//
//        }
//    }
//}

struct TitleScreen_Previews: PreviewProvider {
    static var previews: some View {
        TitleScreen()
    }
}

