//
//  ContentView.swift
//  deezer-search
//
//  Created by Bogdan Petrovskiy on 10.08.22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: TrackListViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchTerm: $viewModel.searchTerm)
                if viewModel.tracks.isEmpty {
                    EmptyStateView()
                } else {
                    List(viewModel.tracks) { track in
                        TrackView(track: track)
                    }
                        .listStyle(PlainListStyle())
                }
            }
                .navigationBarTitle("Music Search")
        }
    }
}

struct TrackView: View {
    @ObservedObject var track: TrackViewModel
    
    var body: some View {
        HStack {
            CoverView(cover: track.cover)
                .padding(.trailing)
            VStack {
                HStack {
                    Text(track.title)
                    if track.isExplicit {
                        Image(systemName: "e.square.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 12))
                    }
                    Spacer()
                }
                HStack {
                    Text("\(track.artist.name) | \(track.album.title)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
            Spacer()
            Text("\(track.duration >= 3600 ? track.duration.hh_mm_ss : track.duration.mm_ss)")
        }
            .padding()
    }
}

struct CoverView: View {
    let cover: Image?
    
    var body: some View {
        ZStack {
            if cover != nil {
                cover?
                    .resizable()
                    .frame(width: 70, height: 70)
            } else {
                Color(.systemIndigo)
                Image(systemName: "music.note")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        }
        .frame(width: 50, height: 50)
        .shadow(radius: 5)
        .padding(.trailing, 5)
    }
}

struct SearchBar: UIViewRepresentable {
    typealias UIViewType = UISearchBar
    
    @Binding var searchTerm: String
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Type there..."
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) { }
    
    class SearchBarCoordinator: NSObject, UISearchBarDelegate {
        @Binding var searchTerm: String
        
        init(searchTerm: Binding<String>) {
            self._searchTerm = searchTerm
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchTerm = searchBar.text ?? ""
            UIApplication.shared.windows.first { $0.isKeyWindow }?.endEditing(true)
        }
    }
    
    func makeCoordinator() -> SearchBarCoordinator {
        return SearchBarCoordinator(searchTerm: $searchTerm)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack() {
            Spacer()
            Image(systemName: "music.note")
                .font(.system(size: 85))
                .padding(.bottom)
            Text("Start searching for music...")
                .font(.title)
            Spacer()
        }
            .padding()
            .foregroundColor(Color(.systemIndigo))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: TrackListViewModel())
    }
}
