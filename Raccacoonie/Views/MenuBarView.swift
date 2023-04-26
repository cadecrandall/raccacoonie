//
//  MenuBarView.swift
//  Raccacoonie
//
//  Created by Cade Crandall on 4/26/23.
//

import SwiftUI

struct MenuBarView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.currentTrack.name).font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .foregroundStyle(.ultraThickMaterial)
            
            
            
            Text("\(viewModel.currentTrack.album.name) by \(viewModel.currentTrack.artist)")
                .foregroundColor(.black)
            
            Divider()
            

                AsyncImage(url: viewModel.currentTrack.album.coverUrl) { image in
                    image.resizable().frame(width: 300.0, height: 300.0)
                } placeholder: {
                    ProgressView()
                }

            
            
            Divider()
            
            HStack {
                Button(action: {viewModel.skipToPreviousPlayback()}, label: {
                    Label("Skip Previous", systemImage: "backward.fill")
                        .labelStyle(.iconOnly)
                        .frame(maxWidth: .infinity)
                }).buttonStyle(.plain)
                
                Button(action: {viewModel.pauseCurrentPlayback()}, label: {
                    Label(viewModel.isPlaying ? "Pause" : "Play", systemImage: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .labelStyle(.iconOnly)
                        .frame(maxWidth: .infinity)
                }).buttonStyle(.plain)
                
                Button(action: {viewModel.skipPlayback()}, label: {
                    Label("Skip", systemImage: "forward.fill")
                        .labelStyle(.iconOnly)
                        .frame(maxWidth: .infinity)
                }).buttonStyle(.plain)
            }
            
            Divider()
            
            Button("Refresh App") {
                viewModel.updatePlayback()
            }.keyboardShortcut("R")
            
        }.background(.ultraThinMaterial)
    }
}
