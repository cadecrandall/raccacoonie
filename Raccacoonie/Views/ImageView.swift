//
//  ImageView.swift
//  Raccacoonie
//
//  Created by Cade Crandall on 4/10/23.
//

import SwiftUI

struct ImageView: View {
    
    let imageUrl: URL
    
    var body: some View {
        AsyncImage(url: imageUrl) { image in 
            image.resizable().frame(width: 300.0, height: 300.0)
        } placeholder: {
            ProgressView()
        }        
    }
}

