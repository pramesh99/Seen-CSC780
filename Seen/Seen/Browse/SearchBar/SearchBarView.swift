//
//  SearchBarView.swift
//  Seen
//
//  Created by Preetham Ramesh on 4/29/24.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchResults: [MovieDetailsModel]
    
    @StateObject private var movieSearchVM = DebounceTextFieldModel()
    @FocusState private var searchIsFocused: Bool
    @State private var showCancelButton = false
    
    var body: some View {
        HStack {
            HStack {
                // MARK: Search bar
                Image(systemName: "magnifyingglass")
                    .foregroundColor((searchIsFocused ? SystemColors.primaryColor : SystemColors.secondaryColor))
                TextField("", text: $movieSearchVM.inputText)
                    .focused($searchIsFocused)
                    .frame(height: 48)
                    .foregroundColor(SystemColors.primaryColor)
                    .background {
                        ZStack {
                            if movieSearchVM.inputText == "" {
                                HStack {
                                    Text("Search for a movie")
                                        .foregroundColor(SystemColors.secondaryColor)
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                // MARK: Remove text button
                if movieSearchVM.inputText != "" {
                    Button(action: {
                        movieSearchVM.inputText = ""
                    }) {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(SystemColors.secondaryColor)
                    }
                    .transition(.opacity)
                }
            }
            .onChange(of: searchIsFocused) { bool in
                withAnimation(.easeInOut(duration: 0.2)) {
                    showCancelButton = bool
                }
            }
            .padding(.horizontal)
            .background(SystemColors.backgroundColor)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(
                        (searchIsFocused ? SystemColors.primaryColor : SystemColors.secondaryColor),
                        lineWidth: 1))
            
            // MARK: Cancel button
            if showCancelButton || movieSearchVM.inputText != "" {
                Button("Cancel") {
                    movieSearchVM.inputText = ""
                    searchIsFocused = false
                }
                .foregroundColor(SystemColors.primaryColor)
                .transition(.move(edge: .trailing))
            }
        }
        .onChange(of: movieSearchVM.inputText, perform: { searchValue in
            if searchValue.isEmpty {
                searchResults = []
            }
        })
        .onChange(of: movieSearchVM.debouncedText, perform: queryTMDBSearch)
        .padding(.horizontal, 10)
        .onAppear {
            if movieSearchVM.inputText != "" {
                searchIsFocused = true
            }
        }
    }
    
    private func queryTMDBSearch(queryString: String) -> Void {
        if queryString.isEmpty {
            searchResults = []
            return
        }
        /**
         * TODO: Make a server call instead which then calls the OMDB API
         */
        let headers = ["accept": "application/json",
                       "Authorization": APIKeys.tmdb.rawValue]
        
        let escapedQuery = queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let request = NSMutableURLRequest(
            url: NSURL(string: "https://api.themoviedb.org/3/search/movie?query=\(escapedQuery!)&include_adult=false&language=en-US&page=1")! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let error = error {
                fatalError("Error getting response from TMDB. \(error as Any)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                fatalError("Status code error. \(String(describing: response as? HTTPURLResponse))")
                return
            }
            guard let mimeType = httpResponse.mimeType, mimeType == "application/json",
               let data = data else {
                fatalError("Could not process data. \(String(describing: data))")
                return
            }
            do {
                let dataDict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let results = dataDict?["results"] as? Array<Dictionary<String, Any>> {
                    searchResults = results.compactMap({ resultDict in
                        MovieDetailsModel(fromTDMBSearch: resultDict)
                    })
                }
            } catch {
                fatalError("Could not serialize JSON from data. \(String(describing: data))")
                return
            }
        }

        dataTask.resume()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchResults: .constant([]))
    }
}
