//
//  ViewModel.swift
//  Raccacoonie
//
//  Created by Cade Crandall on 4/10/23.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var track = String()
    @Published var artist = String()
    @Published var album = String()
}
