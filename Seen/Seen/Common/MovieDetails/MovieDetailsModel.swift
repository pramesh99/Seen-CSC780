//
//  MovieDetailsModel.swift
//  Seen
//
//  Created by Preetham Ramesh on 4/29/24.
//

import Foundation

class MovieDetailsModel: ObservableObject, Identifiable {
    var id: String!
    var posterURL: String!
    var title: String!
    var releaseYear: String!
    
    var backdropURL: String!
    
    var mpaRating: String!
    var runtime: String!
    var genres: [String]!
    var director: String!
    var writers: String!
    var mainCast: String!
    var plot: String!
    var imdbURL: String!
    
    init?(fromTDMBSearch movieJSON: Dictionary<String, Any>) {
        guard let id = movieJSON["id"] as? Int,
              let title = movieJSON["title"] as? String,
              let pURL = createTmdbURL(withPath: movieJSON["poster_path"] as? String),
              let releaseDate = movieJSON["release_date"] as? String else {
            return nil
        }
        
        self.id = String(id)
        self.title = title
        self.posterURL = pURL
        self.releaseYear = String(releaseDate.prefix(4))
        
        if let bURL = createTmdbURL(withPath: movieJSON["backdrop_path"] as? String) {
            self.backdropURL = bURL
        }
    }
    
    private func createTmdbURL(withPath: String?) -> String? {
        if let path = withPath {
            return "https://image.tmdb.org/t/p/original/\(path)"
        }
        return nil
    }
    
    /**
     * Returns:
     *  0 : OMDB data error
     *  -1 : Internal error
     *  1 : Success
     */
    func append(fromOMDB movieJSON: Dictionary<String, Any>) -> Int {
        guard let rated = movieJSON["Rated"] as? String,
              let runtime = movieJSON["Runtime"] as? String,
              let allGenres = movieJSON["Genre"] as? String,
              let imdbId = movieJSON["imdbID"] as? String else {
                  return 0
              }
        
        self.mpaRating = rated
        guard let spaceIdx = runtime.firstIndex(of: " "),
              let minutes = Int(runtime[..<spaceIdx]) else {
            return -1
        }
        self.runtime = translateMinutes(minutes)
        self.genres = allGenres.split(separator: ", ", maxSplits: 3).enumerated().compactMap({ index, substring in
            if (index < 3) {
                return String(substring)
            }
            return nil
        })
        guard let iURL = createImdbURL(withPath: imdbId) else {
            return -1
        }
        self.imdbURL = iURL
        
        if let director = movieJSON["Director"] as? String {
            self.director = director
        }
        if let actors = movieJSON["Actors"] as? String {
            self.mainCast = actors
        }
        if let writers = movieJSON["Writer"] as? String {
            self.writers = writers
        }
        if let plot = movieJSON["Plot"] as? String {
            self.plot = plot
        }
        
        return 1
    }
    
    private func translateMinutes(_ minutes: Int) -> String {
        let h = minutes / 60
        let m = minutes - (h * 60)
        
        return "\(h)h \(m)m"
    }
    
    private func createImdbURL(withPath: String?) -> String? {
        if let path = withPath {
            return "https://www.imdb.com/title/\(path)"
        }
        
        return nil
    }
}
