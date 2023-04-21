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
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text("Raccacoonie!")
            Link("Authorize Spotify Access", destination: viewModel.getAuthUrl())
            
            if viewModel.isAuthorized {
                
                
                VStack {
                    HStack {
                        Button("Get recent playback tracks") { viewModel.loadRecentlyPlayed() }
                        Text("Recently played:")
                    }
                    HStack {
                        Button("Get current track") { viewModel.getCurrentTrack() }
                        Text("Current Track:")
                        Text(viewModel.currentTrack.name)
                    }
                }
                
                WidgetView(track: SpotifyWrapper.random())
            }
        }
        
        .padding()
        .onOpenURL(perform: viewModel.handleURL(_:))
    }
    
}
