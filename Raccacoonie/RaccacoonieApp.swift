//
//  RaccacoonieApp.swift
//  Raccacoonie
//
//  Created by Cade Crandall on 4/4/23.
//

import SwiftUI

@main
struct RaccacoonieApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.commands {
            CommandGroup(replacing: .newItem, addition: { })
        }
    }
}
