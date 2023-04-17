//
//  ViewModel.swift
//  Raccacoonie
//
//  Created by Cade Crandall on 4/10/23.
//

import Foundation
import SpotifyWebAPI
import Combine

class ViewModel: ObservableObject {
    
    let spotify = SpotifyAPI(
        authorizationManager: AuthorizationCodeFlowManager(
            clientId: ProcessInfo.processInfo.environment["CLIENT_ID"]!, clientSecret: ProcessInfo.processInfo.environment["CLIENT_SECRET"]!
        )
    )
    
    let loginCallbackURL = URL(
        string: "raccacoonie://login-callback"
    )!
    
    var authorizationState = String.randomURLSafe(length: 128)
    
    var recentlyPlayed: [CCCTrack] = []
    
    private var loadRecentlyPlayedCancellable: AnyCancellable? = nil
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    func getAuthUrl() -> URL {
        // from https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/Model/Spotify.swift
        
        /// A cryptographically-secure random string used to ensure than an incoming
        /// redirect from Spotify was the result of a request made by this app, and
        /// not an attacker. **This value is regenerated after each authorization**
        /// **process completes.**
        
        
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
    
    func handleURL(_ url: URL) {
        // from https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/Model/Spotify.swift
        
        // **Always** validate URLs; they offer a potential attack vector into
        // your app.
        guard url.scheme == loginCallbackURL.scheme else {
            print("not handling URL: unexpected scheme: '\(url)'")
            return
        }
        
        print("received redirect from Spotify: '\(url)'")
        
        // Complete the authorization process by requesting the access and
        // refresh tokens.
        spotify.authorizationManager.requestAccessAndRefreshTokens(
            redirectURIWithQuery: url,
            // This value must be the same as the one used to create the
            // authorization URL. Otherwise, an error will be thrown.
            state: authorizationState
        )
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
            
            /*
             After the access and refresh tokens are retrieved,
             `SpotifyAPI.authorizationManagerDidChange` will emit a signal,
             causing `Spotify.authorizationManagerDidChange()` to be called,
             which will dismiss the loginView if the app was successfully
             authorized by setting the @Published `Spotify.isAuthorized`
             property to `true`.
             
             The only thing we need to do here is handle the error and show it
             to the user if one was received.
             */
            if case .failure(let error) = completion {
                print("couldn't retrieve access and refresh tokens:\n\(error)")
                let alertTitle: String
                let alertMessage: String
                if let authError = error as? SpotifyAuthorizationError,
                   authError.accessWasDenied {
                    alertTitle = "You Denied The Authorization Request :("
                    alertMessage = ""
                }
                else {
                    alertTitle =
                    "Couldn't Authorization With Your Account"
                    alertMessage = error.localizedDescription
                }
                print(alertTitle)
                print(alertMessage)
            }
        })
        .store(in: &cancellables)
        
        // MARK: IMPORTANT: generate a new value for the state parameter after
        // MARK: each authorization request. This ensures an incoming redirect
        // MARK: from Spotify was the result of a request made by this app, and
        // MARK: and not an attacker.
//        authorizationState = String.randomURLSafe(length: 128)
        
    }
    
    
    
}
