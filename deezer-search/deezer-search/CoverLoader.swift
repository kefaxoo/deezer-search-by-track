//
//  CoverLoader.swift
//  deezer-search
//
//  Created by Bogdan Petrovskiy on 10.08.22.
//

import Foundation
import SwiftUI

class CoverLoader {
    private var dataTasks: [URLSessionDataTask] = []
    
    func loadCover(forTrack track: Track, completion: @escaping((Image?) -> Void)) {
        guard let imageURL = URL(string: track.album.coverURL) else {
            completion(nil)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            guard let data = data, let cover = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            let image = Image(uiImage: cover)
            completion(image)
        }
        
        dataTasks.append(dataTask)
        dataTask.resume()
    }
    
    func reset() {
        dataTasks.forEach { $0.cancel() }
    }
}
