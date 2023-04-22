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
            
            if !viewModel.isAuthorized {
                Link("Authorize Spotify Access", destination: viewModel.getAuthUrl())
            } else {
                VStack {
                    Button("Update current track") { viewModel.updateCurrentTrack() }
                    HStack {
                        Button("Back") {}
                        Button("Play/Pause") { viewModel.pauseCurrentPlayback() }
                        Button("Forward") {}
                    }
                    WidgetView(track: viewModel.currentTrack)
                }
            }
        }
        
        .padding()
        .onOpenURL(perform: viewModel.handleURL(_:))
    }
    
}
