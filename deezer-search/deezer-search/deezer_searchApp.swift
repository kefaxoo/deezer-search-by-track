//
//  deezer_searchApp.swift
//  deezer-search
//
//  Created by Bogdan Petrovskiy on 10.08.22.
//

import SwiftUI

@main
struct deezer_searchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: TrackListViewModel())
        }
    }
}
