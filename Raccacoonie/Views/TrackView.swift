//
//  WidgetView.swift
//  Raccacoonie
//
//  Created by Cade Crandall on 4/17/23.
//

import SwiftUI

struct TrackView: View {
    // TODO: Style this view to be prettier!
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
            
            ImageView(imageUrl: track.album.coverUrl)
                .aspectRatio(contentMode: .fit)
                .padding(20)
        }
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView(track: SpotifyWrapper.random())
    }
}
