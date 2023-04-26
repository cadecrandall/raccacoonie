//
//  Track.swift
//  Raccacoonie
//
//  Created by Cade Crandall on 4/16/23.
//

import Foundation

struct CCCTrack: CustomStringConvertible {
    let name: String
    let artist: String
    let album: CCCAlbum
    let uri: String?
    let id = UUID()
    
    var description: String {
        return "CCCTrack: {\(name) by \(artist) on album \(album)}"
    }
}

