//
//  DataModel.swift
//  deezer-search
//
//  Created by Bogdan Petrovskiy on 10.08.22.
//

import Foundation

class DataModel {
    private var dataTask: URLSessionDataTask?
    
    func loadSongs(searchTerm: String, completion: @escaping(([Track]) -> Void)) {
        dataTask?.cancel()
        guard let url = buildURL(forTerm: searchTerm) else {
            completion([])
            return
        }
        
        dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }
            
            if let trackResponse = try? JSONDecoder().decode(TracksResponse.self, from: data) { completion(trackResponse.tracks) }
        }
        
        dataTask?.resume()
    }
    
    private func buildURL(forTerm searchTerm: String) -> URL? {
        guard !searchTerm.isEmpty else { return nil }
        
        let queryItems = [
            URLQueryItem(name: "q", value: searchTerm),
        ]
        
        var components = URLComponents(string: "https://api.deezer.com/search/track")
        components?.queryItems = queryItems
        return components?.url
    }
}

struct TracksResponse: Decodable {
    let tracks: [Track]
    let total: Int
    let next: String
    
    enum CodingKeys: String, CodingKey {
        case tracks = "data"
        case total
        case next
    }
}

struct Track: Decodable {
    let id: Int
    let title: String
    let titleShort: String
    let link: String
    let duration: TimeInterval
    let isExplicit: Bool
    let previewURL: String
    let artist: Artist
    let album: Album
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case titleShort = "title_short"
        case link
        case duration
        case isExplicit = "explicit_lyrics"
        case previewURL = "preview"
        case artist
        case album
        case type
    }
}

struct Artist: Decodable {
    let id: Int
    let name: String
    let link: String
    let pictureURL: String
    let bigPictureURL: String
    let tracklist: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case link
        case pictureURL = "picture"
        case bigPictureURL = "picture_xl"
        case tracklist
        case type
    }
}

struct Album: Decodable {
    let id: Int
    let title: String
    let coverURL: String
    let bigCoverURL: String
    let tracklist: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case coverURL = "cover"
        case bigCoverURL = "cover_xl"
        case tracklist
        case type
    }
}
