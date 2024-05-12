//
//  MovieDetailsView.swift
//  Seen
//
//  Created by Preetham Ramesh on 4/29/24.
//

import SwiftUI
import Firebase

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct RatingsModal: View {
    @Binding var isModalPresented: Bool
    @Binding var rating: Double
    @State var newRating: Double = 0.0

    var movieModel: MovieDetailsModel
    
    var body: some View {
        ZStack{
            SystemColors.imageBackgroundColor
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Rate \(movieModel.title)")
                    .font(.title)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    
                Text("\(newRating, specifier: "%.1f")")
                    .foregroundStyle(.white)
                
                Slider(value: $newRating, in: 0.0...10.0, step: 0.1)
                                .padding()
                
                HStack {
                    Spacer()
                    Button("Cancel") {
                        // Dismiss the modal
                        isModalPresented = false
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Button("Submit"){
                        // send rating to db
                        var d = UserDefaults.standard.dictionary(forKey: "cachedRatings")
                        let mid = movieModel.id
                        d![mid!] = newRating
                        UserDefaults.standard.set(d, forKey: "cachedRatings")
                        rating = round(newRating * 10) / 10.0
                        SubmitHandler(movieModel: movieModel, rating: newRating)
                        isModalPresented = false
                    }
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                   
                    Spacer()
                }
                
            }
            .cornerRadius(10)
            .padding()

        }
    }
}
func toDictionary(movieModel: MovieDetailsModel) -> [String: Any]{
    var output: [String: Any] = [:]
    
    let mirror = Mirror(reflecting: movieModel)
    for (label, value) in mirror.children {
        output[label ?? "Unknown"] = value
        print("\(label ?? "Unknown"): \(value)")
    }
    
//    print("Dictionary version: \(output as AnyObject)")
    return output
}

func SubmitHandler(movieModel: MovieDetailsModel, rating: Double) {
    let d = toDictionary(movieModel: movieModel)
    sendRating(movieDict: d, rating: rating)
}

func sendRating(movieDict: [String: Any], rating: Double) {
    var movieDict: [String: Any] = movieDict
    let ratingsCollection = Firestore.firestore().collection("Ratings")
    movieDict["userID"] = UserDefaults.standard.string(forKey: "userID") ?? "MuUwlVs578pYzwLSrsjT"
    movieDict["created"] = FieldValue.serverTimestamp()
    movieDict["rating"] = rating
    var docID: DocumentReference? = nil
    docID = ratingsCollection.addDocument(data: movieDict) { error in
        if let error = error {
            // display error message
            print("Error: \(error)")
        } else {
            print("successfully rated.")
        }
    }
}



struct MovieDetailsView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isModalPresented = false
    @Binding var detailsVM: MovieDetailsModel
    @State var scrollOffset: CGFloat = 0
    @State var rating: Double = -1.0
    
//    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//    let statusBarHeight = windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//    let navBarHeight = UINavigationController().navigationBar.bounds.size.height
    let statusBarHeight: CGFloat = 0
    let navBarHeight: CGFloat = 108
    
    func checkCache() {
        let d = UserDefaults.standard.dictionary(forKey: "cachedRatings")
        print("\(d as AnyObject)")
        if let val = d?[detailsVM.id] as? Double {
            rating = val
        } else {
            print("make api call")
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                ZStack {
                    // MARK: Backdrop image
                    Rectangle()
                        .foregroundColor(SystemColors.backgroundColor)
                        .frame(width: UIScreen.main.bounds.width, height: 320)
                        .edgesIgnoringSafeArea(.top)
                    if detailsVM.backdropURL != nil {
                        AsyncImage(url: URL(string: detailsVM.backdropURL)) { phase in
                            switch phase {
                            case .empty:
                                EmptyView()
                            case .success(let image):
                                ZStack {
                                    image.resizable()
                                        .scaledToFill()
                                    // DO NOT move to ZStack property
                                        .frame(width: UIScreen.main.bounds.width, height: 320, alignment: .center)
                                        .clipped()
                                    Rectangle()
                                        .foregroundColor(.black)
                                        .opacity(0.8)
                                        .frame(width: UIScreen.main.bounds.width, height: 320)
                                }
                                .edgesIgnoringSafeArea(.top)
                            case .failure:
                                EmptyView()
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
                .overlay(alignment: .bottom) {
                    MovieRowView(movieDetailsVM: detailsVM, viewState: .detail())
                        .padding(.bottom, 16)
                        .background(
                            GeometryReader { proxy in
                                let offset = proxy.frame(in: .named("DetailsScrollView")).minY
                                Color.clear.preference(key: ViewOffsetKey.self, value: proxy.size.height - offset)
                            }
                        )
                        .onPreferenceChange(ViewOffsetKey.self) { position in
                            print("\(navBarHeight + statusBarHeight)")
                            print("Offset: \(position)")
                            self.scrollOffset = position
                        }
                }
                .padding(.bottom, 12)
                // MARK: Details
                VStack(alignment: .leading, spacing: 16) {
                    if detailsVM.director != nil {
                        Text("Director: ")
                            .fontWeight(.bold)
                        + Text(detailsVM.director)
                    }
                    if detailsVM.writers != nil {
                        Text("Writers: ")
                            .fontWeight(.bold)
                        + Text(detailsVM.writers)
                    }
                    if detailsVM.mainCast != nil {
                        Text("Stars: ")
                            .fontWeight(.bold)
                        + Text(detailsVM.mainCast)
                    }
                    if detailsVM.plot != nil {
                        Text(detailsVM.plot)
                    }
                    if detailsVM.imdbURL != nil {
                        Link(destination: URL(string: detailsVM.imdbURL)!) {
                            HStack {
                                Text("View More")
                                    .foregroundColor(SystemColors.secondaryColor)
                                Image("Link")
                            }
                        }
                    }
                }
                .padding(.leading, 18)
                .onAppear{
                    checkCache()
                }
                Rectangle()
                    .foregroundColor(SystemColors.imageBackgroundColor)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 1)
                if rating >= 0.0{
                    Text("Your rating: \(rating, specifier: "%.1f")")
                } else {
                    Text("No activity yet.")
                        .foregroundColor(SystemColors.secondaryColor)
                        .padding(.top, 16)
                }
                
            }
            Rectangle()
                .foregroundColor(SystemColors.backgroundColor)
                .frame(width: UIScreen.main.bounds.width, height: 108, alignment: .center)
                .edgesIgnoringSafeArea(.top)
                .opacity(Double((self.scrollOffset - 88) / 42))
        }
        .coordinateSpace(name: "DetailsScrollView")
        .edgesIgnoringSafeArea(.top)
        .foregroundColor(SystemColors.primaryColor)
        .background(SystemColors.backgroundColor)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image("Back")
                }
            }
            ToolbarItem(placement: .principal) {
                Text(detailsVM.title)
                    .opacity(Double((self.scrollOffset - 100) / 30))
                    .foregroundColor(SystemColors.primaryColor)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                
                HStack {
                    Button {
                        // Add to watchlist
                    } label: {
                        Image("Bookmark")
                    }
                    Button {
                        // Rank
                        Mirror(reflecting: detailsVM).children.forEach { child in
                            guard let propertyName = child.label else { return }
                            print("\(propertyName): \(child.value)")
                        }
                        isModalPresented = true
                    } label: {
                        HStack(spacing: 5) {
                            Image("Star")
                            Text("Rank")
                                .fontWeight(.medium)
                                .foregroundColor(SystemColors.primaryColor)
                                
                        }
                        
                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 16))
                    }
                    .background(SystemColors.accentColor)
                    .cornerRadius(4)

                }
            }
        }.sheet(isPresented: $isModalPresented, content: {
            RatingsModal(isModalPresented: $isModalPresented, rating: $rating, movieModel: detailsVM)
                .presentationDetents([.fraction(0.3)])
        })
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationStack {
            MovieDetailsView(detailsVM: .constant(MockMovieDetailsModel.SpiritedAway(.full).detailModel))
                .background(SystemColors.backgroundColor)
                .environment(\.font, .inter())
        }
    }
}
