//
//  ContentView.swift
//  Raccacoonie
//
//  Created by Cade Crandall on 4/4/23.
//

import SwiftUI
import SpotifyWebAPI
import AppKit


struct ContentView: View {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text("Raccacoonie!")
                .font(.title)
            
            if !viewModel.isAuthorized {
                Link("Authorize Spotify Access", destination: viewModel.getAuthUrl())
            } else {
                VStack {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                        .onTapGesture { viewModel.updatePlayback() }
                    
                    TrackView(track: viewModel.currentTrack)
                    
                    AlbumView(track: viewModel.currentTrack)
                        .aspectRatio(contentMode: .fit)
                        .padding(20)
                    
                    PlaybackControllerView(viewModel: viewModel)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
            }
        }
        .padding()
        .onOpenURL(perform: viewModel.handleURL(_:))
    }
    
}
