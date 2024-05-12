//
//  BrowseView.swift
//  Seen
//
//  Created by Preetham Ramesh on 4/29/24.
//

import SwiftUI

struct BrowseView: View {
    @State private var searchResults: Array<MovieDetailsModel> = []
    
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().standardAppearance = navBarAppearance
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBarView(searchResults: $searchResults)
                ScrollView {
                    VStack {
                        ForEach(searchResults) { movie in
                            NavigationLink(destination: MovieDetailsView(detailsVM: .constant(movie))) {
                                MovieRowView(movieDetailsVM: movie, viewState: .search())
                            }
                            .simultaneousGesture(TapGesture().onEnded({ _ in
                                populateOMDBQuery(into: movie)
                            }))
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(SystemColors.backgroundColor)
        }
    }
    
    func populateOMDBQuery(into movie: MovieDetailsModel, withoutYear: Bool = false) {
        /**
         * TODO: Make a server call instead which then calls the OMDB API
         */
        
        let escapedQuery = movie.originalTitle.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        var request = URLRequest(url: URL(string: "https://www.omdbapi.com/?apikey=\(APIKeys.omdb.rawValue)&type=movie&plot=short&t=\(escapedQuery!)\(withoutYear ? "" : "&y=\(movie.releaseYear!)")")!,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                fatalError("Error getting response from TMDB. \(error as Any)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                fatalError("Status code error. \(String(describing: response as? HTTPURLResponse))")
                return
            }
            guard let data = data else {
                fatalError("Could not process data. \(String(describing: data))")
                return
            }
            do {
                if let result = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    let successfulAppend = movie.append(fromOMDB: result)
                    if successfulAppend != 1 {
                        if successfulAppend == 0 {
                            if withoutYear {
                                print("ODMB data was improper")
                                return
                            }
                            populateOMDBQuery(into: movie, withoutYear: true)
                        }
                        print("Unable to process OMDB data")
                    }
                }
            } catch {
                fatalError("Could not serialize JSON from data. \(String(describing: data))")
                return
            }
        }

        task.resume()

    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
            .background(SystemColors.backgroundColor)
    }
}
