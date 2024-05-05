//
//  MovieDetailsView.swift
//  Seen
//
//  Created by Preetham Ramesh on 4/29/24.
//

import SwiftUI

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

struct MovieDetailsView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var detailsVM: MovieDetailsModel
    @State var scrollOffset: CGFloat = 0
    
//    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//    let statusBarHeight = windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//    let navBarHeight = UINavigationController().navigationBar.bounds.size.height
    let statusBarHeight: CGFloat = 0
    let navBarHeight: CGFloat = 108
    
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
                Rectangle()
                    .foregroundColor(SystemColors.imageBackgroundColor)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 1)
                Text("No activity yet.")
                    .foregroundColor(SystemColors.secondaryColor)
                    .padding(.top, 16)
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
        }
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
