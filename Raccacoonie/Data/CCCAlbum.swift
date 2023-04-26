//
//  CCCAlbum.swift
//  Raccacoonie
//
//  Created by Cade Crandall on 4/17/23.
//

import Foundation

struct CCCAlbum: CustomStringConvertible {
    let name: String
    let coverUrl: URL
    let uri: String
    let id = UUID()
    
    var description: String {
        return "CCCAlbum: {\(name)}"
    }
}
