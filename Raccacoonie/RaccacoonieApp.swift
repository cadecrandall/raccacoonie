//
//  RaccacoonieApp.swift
//  Raccacoonie
//
//  Created by Cade Crandall on 4/4/23.
//

import SwiftUI

@main
struct RaccacoonieApp: App {
   
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        // https://www.reddit.com/r/SwiftUI/comments/m5yw4o/url_schemeonopenurl_always_opens_a_new_window/
        // glue code to keep the scheme from opening in a new window
        WindowGroup {
            ContentView(viewModel: viewModel).handlesExternalEvents(preferring: Set(arrayLiteral: "pause"), allowing: Set(arrayLiteral: "*"))
        }.commands {
            CommandGroup(replacing: .newItem, addition: { })
        }.handlesExternalEvents(matching: Set(arrayLiteral: "*"))
        
        
        MenuBarExtra("Raccacoonie", systemImage: "music.note.house.fill") {
            MenuBarView(viewModel: viewModel)
        }.menuBarExtraStyle(.window)
    }
}
