//
//  GenreTagView.swift
//  Seen
//
//  Created by Preetham Ramesh on 4/29/24.
//

import SwiftUI

struct GenreTagView: View {
    var genre: String
    
    var cornerRadius: CGFloat = 4
    
    var body: some View {
        Text(genre.uppercased())
            .foregroundColor(SystemColors.primaryColor)
            .font(.inter(.semibold, size: 11))
            .tracking(0.04)
            .padding(.horizontal, 12)
            .padding(.vertical, 6.5)
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(SystemColors.secondaryColor, lineWidth: 1))
    }
}

struct GenreTileView_Previews: PreviewProvider {
    static var previews: some View {
        GenreTagView(genre: "Comedy")
            .background(SystemColors.backgroundColor)
    }
}
