//
//  ContentView.swift
//  Raccacoonie
//
//  Created by Cade Crandall on 4/4/23.
//

import SwiftUI
import SpotifyWebAPI
import AppKit

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    var debug: String = "debug text"
    
    var body: some View {
        VStack {
            Text("Raccacoonie!")
            // TODO: This tends to open the redirect as a new window, not sure why.
            Link("Authorize Spotify Access", destination: getAuthUrl())
            HStack {
                Text(viewModel.track)
                Text(viewModel.artist)
                Text(viewModel.album)
            }
        }
        .padding()
        
        
    }
    
    
    private func getAuthUrl() -> URL {
        // from https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/Model/Spotify.swift
        
        let spotify = SpotifyAPI(
            authorizationManager: AuthorizationCodeFlowManager(
                clientId: ProcessInfo.processInfo.environment["CLIENT_ID"]!, clientSecret: ProcessInfo.processInfo.environment["CLIENT_SECRET"]!
            )
        )
        
        /// A cryptographically-secure random string used to ensure than an incoming
        /// redirect from Spotify was the result of a request made by this app, and
        /// not an attacker. **This value is regenerated after each authorization**
        /// **process completes.**
        let authorizationState = String.randomURLSafe(length: 128)
        
        let loginCallbackURL = URL(
            string: "raccacoonie://login-callback"
        )!
        
        let authorizationURL = spotify.authorizationManager.makeAuthorizationURL(
            redirectURI: loginCallbackURL,
            showDialog: false,
            scopes: [
                .playlistModifyPrivate,
                .userModifyPlaybackState,
                .playlistReadCollaborative,
                .userReadPlaybackPosition
            ]
        )!
        
        let url = spotify.authorizationManager.makeAuthorizationURL(
            redirectURI: loginCallbackURL,
            showDialog: true,
            state: authorizationState,
            scopes: [
                .userReadPlaybackState,
                .userReadRecentlyPlayed
            ]
        )!
        
        
        return url
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

