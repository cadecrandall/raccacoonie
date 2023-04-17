//
//  WidgetView.swift
//  Raccacoonie
//
//  Created by Cade Crandall on 4/17/23.
//

import SwiftUI

struct WidgetView: View {
    let track: CCCTrack
    
    var body: some View {
        VStack {
            Text(track.name)
            Text(track.artist)
//            ImageView(imageUrl: track.album.coverUrl)
            Image("vw")
            Text(track.album.name)
        }
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView(track: SpotifyWrapper.random())
    }
}