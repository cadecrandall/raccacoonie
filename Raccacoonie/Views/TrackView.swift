//
//  WidgetView.swift
//  Raccacoonie
//
//  Created by Cade Crandall on 4/17/23.
//

import SwiftUI

struct TrackView: View {
    let track: CCCTrack
    
    var body: some View {
        VStack {
            Text(track.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            // TODO: add marquee effect when the text overflows? 
            Text("\(track.album.name) by \(track.artist)")
                .foregroundColor(.gray)
        }
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView(track: SpotifyWrapper.random())
    }
}
