//
//  TrackListViewModel.swift
//  deezer-search
//
//  Created by Bogdan Petrovskiy on 10.08.22.
//

import Foundation
import SwiftUI
import Combine

class TrackListViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published public private(set) var tracks: [TrackViewModel] = []
    
    private let dataModel = DataModel()
    private let coverLoader = CoverLoader()
    private var disposables = Set<AnyCancellable>()
    
    init () {
        $searchTerm
            .sink(receiveValue: loadTracks(searchTerm:))
            .store(in: &disposables)
    }
    
    private func loadTracks(searchTerm: String) {
        tracks.removeAll()
        coverLoader.reset()
        dataModel.loadSongs(searchTerm: searchTerm) { tracks in
            tracks.forEach { self.appendTrack(track: $0) }
        }
    }
    
    private func appendTrack(track: Track) {
        let trackViewModel = TrackViewModel(track: track)
        DispatchQueue.main.async {
            self.tracks.append(trackViewModel)
        }
        
        coverLoader.loadCover(forTrack: track) { image in
            DispatchQueue.main.async {
                trackViewModel.cover = image
            }
        }
    }
}

class TrackViewModel: Identifiable, ObservableObject {
    let id: Int
    let title: String
    let artist: Artist
    let album: Album
    let duration: TimeInterval
    let isExplicit: Bool
    @Published var cover: Image?
    
    init(track: Track) {
        self.id = track.id
        self.title = track.title
        self.artist = track.artist
        self.album = track.album
        self.duration = track.duration
        self.isExplicit = track.isExplicit
    }
}
