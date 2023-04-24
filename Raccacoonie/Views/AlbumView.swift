//
//  ImageView.swift
//  Raccacoonie
//
//  Created by Cade Crandall on 4/10/23.
//

import SwiftUI

struct AlbumView: View {
    
    let track: CCCTrack
    
    var body: some View {
        AsyncImage(url: track.album.coverUrl) { image in
            image.resizable().frame(width: 300.0, height: 300.0)
        } placeholder: {
            ProgressView()
        }        
    }
}

