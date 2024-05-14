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
    //state array of movieDetailModels
    @State private var rankings: [MovieDetailsModel] = []
    @State var combined: [(MovieDetailsModel, String)] = []
    @State var scores: [String] = []
    @State var iterator: Int = 0
  
    func fetchData() async {
        rankings = []
        scores = []
        combined = []
        do {
            let ratingsCollection = Firestore.firestore().collection("Ratings")
            let snapshot = try await ratingsCollection.whereField("userID", isEqualTo: UserDefaults.standard.string(forKey: "userID") ?? "MuUwlVs578pYzwLSrsjT")
                .order(by: "created", descending: true)
                .getDocuments()
            // create movieDetailsModel array
            for document in snapshot.documents {
                // make a new mdm and add it to the array
                let movieJSON: [String:Any] = [
                    "id": Int(document.data()["id"] as! String) ?? Int(document.data()["movieID"] as! String) ?? 0,
                    "title": document.data()["title"] as? String ?? "",
                    "original_title": document.data()["originalTitle"] ?? "",
                    "poster_path": document.data()["posterURL"] ?? "",
                    "release_date": document.data()["releaseYear"] ?? "",
                    "backdrop_path": document.data()["backdropURL"] ?? "",
                ]

                if let mmodel = MovieDetailsModel(fromTDMBSearch: movieJSON){
                    rankings.append(mmodel)
                    if let score = document.data()["rating"] as? Double {
                        scores.append(String(format: "%.1f", score))
                        combined.append((mmodel, String(format: "%.1f", score)))
                    }
                }
            }
            print("Done fetching")
            UserDefaults.standard.set(scores.count, forKey: "numRated")
            
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
                            ForEach(combined.indices, id: \.self) { index in
                                let movie = combined[index]
                                NavigationLink(destination: MovieDetailsView(detailsVM: .constant(movie.0))) {
                                    MovieRowView(movieDetailsVM: movie.0, viewState: .feed(), rating: movie.1)
                                }
                                .simultaneousGesture(TapGesture().onEnded({ _ in
                                    populateOMDBQuery(into: movie.0)
                                }))
                            }
                        }.frame(maxHeight: .infinity, alignment: .top)
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

struct Feed_Previews: PreviewProvider {
    static var previews: some View {
        Feed()
    }
}
