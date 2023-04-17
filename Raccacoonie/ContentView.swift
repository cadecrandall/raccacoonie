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
            // TODO: This tends to open the redirect as a new window, not sure why.
            Link("Authorize Spotify Access", destination: viewModel.getAuthUrl())
            Button("Get current track") { viewModel.getCurrentTrack() }
            
            WidgetView(track: SpotifyWrapper.random())
        }
        
        .padding()
        .onOpenURL(perform: viewModel.handleURL(_:))
    }
    
    
}
