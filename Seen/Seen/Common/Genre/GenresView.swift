//
//  GenresView.swift
//  Seen
//
//  Created by Preetham Ramesh on 4/29/24.
//

import SwiftUI

struct GenresView: View {
    let genres: [String]
    
    var spacing: CGFloat = 10
    @State private var totalHeight = CGFloat.zero
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateWrappedTags(geometry)
            }
        }
        .frame(height: totalHeight)
    }
    
    private func generateWrappedTags(_ geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(self.genres, id: \.self) { genre in
                GenreTagView(genre: genre)
                    .alignmentGuide(.leading, computeValue: { tag in
                        if (abs(width - tag.width - spacing) > geometry.size.width) {
                            width = 0
                            height -= (tag.height + spacing)
                        }
                        let result = width
                        if genre == self.genres.last {
                            width = 0 // last item
                        } else {
                            width -= (tag.width + spacing)
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { tag in
                        let result = height
                        if genre == self.genres.last {
                            height = 0 // last item
                        }
                        
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight))
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

struct GenresView_Previews: PreviewProvider {
    static var previews: some View {
        ViewThatFits {
            GenresView(genres: ["Action",
                                "Adventure",
                                "Animation",
                                "Comedy",
                                "Crime",
                                "Documentary",
                                "Drama",
                                "Family",
                                "Fantasy",
                                "History",
                                "Horror",
                                "Music",
                                "Mystery",
                                "Romance",
                                "Science Fiction",
                                "TV Movie",
                                "Thriller",
                                "War",
                                "Western",
                                "Speculative Fiction"])
            .padding(10)
        }
            .background(SystemColors.backgroundColor)
    }
}

