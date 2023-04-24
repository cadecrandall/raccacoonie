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
            Button(action: { viewModel.skipToPreviousPlayback() }) {
                Image(systemName: "backward.fill")
                    .foregroundColor(.blue)
            }
            Button(action: { viewModel.pauseCurrentPlayback() }) {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .foregroundColor(.blue)
            }
            Button(action: { viewModel.skipPlayback() }) {
                Image(systemName: "forward.fill")
                    .foregroundColor(.blue)
            }
        }
    }
}
