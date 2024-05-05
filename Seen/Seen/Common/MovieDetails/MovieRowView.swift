//
//  MovieRowView.swift
//  Seen
//
//  Created by Preetham Ramesh on 4/29/24.
//

import SwiftUI

enum MovieRowViewState: Equatable {
    case search(imageHeight: CGFloat = 63, titleSize: CGFloat = 18, titleWeight: Font.InterWeight = .semibold, detailsSize: CGFloat = 14)
    case feed(imageHeight: CGFloat = 144, titleSize: CGFloat = 20, titleWeight: Font.InterWeight = .bold, detailsSize: CGFloat = 16)
    case detail(imageHeight: CGFloat = 178, titleSize: CGFloat = 24, titleWeight: Font.InterWeight = .bold, detailsSize: CGFloat = 16)
}

struct MovieRowView: View {
    let movieDetailsVM: MovieDetailsModel
    let viewState: MovieRowViewState
    
    // Defaults set with bigger sizes
    var imageHeight: CGFloat = 144
    var imageWidth: CGFloat = 96
    
    var titleSize: CGFloat = 20
    var titleWeight: Font.InterWeight = .bold
    var quickDetailsSize: CGFloat = 16
    
    init(movieDetailsVM: MovieDetailsModel, viewState: MovieRowViewState) {
        self.movieDetailsVM = movieDetailsVM
        self.viewState = viewState
        
        switch viewState {
        case .search(let imageHeight, let titleSize, let titleWeight, let detailsSize),
                .feed(let imageHeight, let titleSize, let titleWeight, let detailsSize),
                .detail(let imageHeight, let titleSize, let titleWeight, let detailsSize):
            self.imageHeight = imageHeight
            self.titleSize = titleSize
            self.titleWeight = titleWeight
            self.quickDetailsSize = detailsSize
        }
        
        self.imageWidth = self.imageHeight * 2 / 3
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            AsyncImage(url: URL(string: movieDetailsVM.posterURL)) { phase in
                switch phase {
                case .empty:
                    self.imageBackgroundRectangle()
                case .success(let image):
                    image.resizable()
//                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: self.imageWidth, maxHeight: self.imageHeight)
                case .failure:
                    self.imageBackgroundRectangle()
                @unknown default:
                    self.imageBackgroundRectangle()
                }
            }
            VStack(alignment: .leading, spacing: 5) {
                // MARK: Title
                Text(movieDetailsVM.title)
                    .foregroundColor(SystemColors.primaryColor)
                    .font(.inter(self.titleWeight, size: self.titleSize))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                // MARK: Quick Details
                HStack {
                    if movieDetailsVM.releaseYear != nil {
                        Text(movieDetailsVM.releaseYear)
                    }
                    if movieDetailsVM.mpaRating != nil {
                        Text("•")
                        Text(movieDetailsVM.mpaRating)
                    }
                    if movieDetailsVM.runtime != nil {
                        Text("•")
                        Text(movieDetailsVM.runtime)
                    }
                }
                .foregroundColor(SystemColors.secondaryColor)
                .font(.inter(size: self.quickDetailsSize))
                
                // MARK: Genres
                if movieDetailsVM.genres != nil {
                    GenresView(genres: movieDetailsVM.genres)
                        .padding(.top, 5)
                }
            }
            if self.viewState == .search() {
                VStack {
                    HStack {
                        Button {
                            
                        } label: {
                            Image("Bookmark")
                        }
                        Button {
                            
                        } label: {
                            // TODO: Replace image with gray or SF Symbol
                            Image("Star")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(height: self.imageHeight, alignment: .center)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func imageBackgroundRectangle() -> some View {
        return Rectangle()
            .background(SystemColors.imageBackgroundColor)
            .foregroundColor(SystemColors.imageBackgroundColor)
            .frame(width: self.imageWidth, height: self.imageHeight)
    }
}

struct SearchResultRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Section("Detail View") {
                MovieRowView(movieDetailsVM: MockMovieDetailsModel.GirlWithDragonTatoo(.full).detailModel, viewState: .detail())
                    .border(.white)
            }
            Section("Feed View") {
                MovieRowView(movieDetailsVM: MockMovieDetailsModel.Barbie(.full).detailModel, viewState: .feed())
                    .border(.white)
            }
            Section("Search View") {
                MovieRowView(movieDetailsVM: MockMovieDetailsModel.SpiritedAway().detailModel, viewState: .search())
                    .border(.white)
            }
        }
        .padding(.vertical, 5)
        .foregroundColor(SystemColors.primaryColor)
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        .background(SystemColors.backgroundColor)
    }
}

