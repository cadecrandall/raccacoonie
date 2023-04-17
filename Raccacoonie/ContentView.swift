//
//  ContentView.swift
//  Raccacoonie
//
//  Created by Cade Crandall on 4/4/23.
//

import SwiftUI
import SpotifyWebAPI
import AppKit
import Combine

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    @State private var loadRecentlyPlayedCancellable: AnyCancellable? = nil
    
    @State private var cancellables: Set<AnyCancellable> = []
        
    
    var body: some View {
        VStack {
            Text("Raccacoonie!")
            // TODO: This tends to open the redirect as a new window, not sure why.
            Link("Authorize Spotify Access", destination: URL(string: "https://google.com")!)
            HStack {
                Text(viewModel.track)
                Text(viewModel.artist)
                Text(viewModel.album)
            }
            Button("Get current track") {  }
            
        }
        
        .padding()
    }
    
    
}
