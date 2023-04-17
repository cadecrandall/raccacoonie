//
//  ImageView.swift
//  Raccacoonie
//
//  Created by Cade Crandall on 4/10/23.
//

import SwiftUI

struct ImageView: View {
    var body: some View {
        AsyncImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Spotify_logo_with_text.svg/2560px-Spotify_logo_with_text.svg.png")) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 150, height: 50)
    }
}

