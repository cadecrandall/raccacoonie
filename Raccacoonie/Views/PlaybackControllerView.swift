//
//  PlaybackControllerView.swift
//  Raccacoonie
//
//  Created by Cade Crandall on 4/24/23.
//

import SwiftUI

struct PlaybackControllerView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "backward.fill")
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .onTapGesture { viewModel.skipToPreviousPlayback() }
            Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                .font(.system(size: viewModel.isPlaying ? 32 : 30))
                .foregroundColor(.blue)
                .onTapGesture { viewModel.pauseCurrentPlayback() }
            Image(systemName: "forward.fill")
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .onTapGesture { viewModel.skipPlayback() }
        }
    }
}
