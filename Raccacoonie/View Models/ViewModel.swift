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
    
    @Published var isAuthorized: Bool = false
    @Published var currentTrack: CCCTrack = SpotifyWrapper.random()
    
    private var loadRecentlyPlayedCancellable: AnyCancellable? = nil
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var authUrl: URL? = nil
    
    private var recentTrack: Track? = nil {
        didSet {
            guard let recentTrack else {
                return
            }
            
            let trackName = recentTrack.name
            let artists = recentTrack.artists
            let album = recentTrack.album
            let uri = recentTrack.uri
            
            guard let artists else {
                return
            }
            
            guard let album else {
                return
            }
            
            guard let uri else {
                return
            }
            
            let cccAlbum = CCCAlbum(name: album.name, coverUrl: URL(string: "google.com")!, uri: album.uri!)
            
            currentTrack = CCCTrack(name: trackName,
                                    artist: artists[0].name,
                                    album: cccAlbum,
                                    uri: uri)
            print(currentTrack)
        }
    }
    
    func getAuthUrl() -> URL {
        // from https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/Model/Spotify.swift
        
        /// A cryptographically-secure random string used to ensure than an incoming
        /// redirect from Spotify was the result of a request made by this app, and
        /// not an attacker. **This value is regenerated after each authorization**
        /// **process completes.**
        
        if authUrl != nil {
            return authUrl!
        }
        
        authUrl = spotify.authorizationManager.makeAuthorizationURL(
            redirectURI: loginCallbackURL,
            showDialog: true,
            state: authorizationState,
            scopes: [
                .userReadPlaybackState,
                .userReadRecentlyPlayed,
                .userReadCurrentlyPlaying
            ]
        )!
        
        return authUrl!
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
        authorizationState = String.randomURLSafe(length: 128)
        
        isAuthorized = true
        
    }
    
    func getCurrentTrack() -> CCCTrack? {
        print("Called get current track")
        
        spotify.currentPlayback().receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                // Handle any errors that occur
                if case .failure(let error) = completion {
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { currentlyPlayingContext in
                guard let context = currentlyPlayingContext else {
                    print("Nothing is currently playing.")
                    return
                }
                
                guard let playlistItem = context.item else {
                    print("The playlist item is empty.")
                    return
                }
                
                switch playlistItem {
                case .track(let track):
                    self.recentTrack = track
                case .episode(_):
                    // TODO: handle podcast episodes?
                    self.recentTrack = nil
                }
                
            })
            .store(in: &cancellables)
        
        return currentTrack
    }
    
    
    func receiveRecentlyPlayedCompletion(_ completion: Subscribers.Completion<Error>) {
        if case .failure(let error) = completion {
            let title = "Couldn't retrieve recently played tracks"
            print("\(title): \(error)")
        }
    }
    
    
    /// Loads the first page. Called when this view appears.
    func loadRecentlyPlayed() {
        
        print("loading first page")
        
        self.loadRecentlyPlayedCancellable = spotify
            .recentlyPlayed(limit: 20)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: self.receiveRecentlyPlayedCompletion(_:),
                receiveValue: { playHistory in
                    let tracks = playHistory.items.map(\.track)
                    print(
                        "received first page with \(tracks.count) items"
                    )
                    self.recentTrack = tracks[0]
                }
            )
        
    }
    
}
