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
    
    @Published var isPlaying: Bool = true
    
    private var loadRecentlyPlayedCancellable: AnyCancellable? = nil
    
    // TODO: when should the cancellables be purged?
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
            
            guard let albumImages = album.images else {
                // TODO: what should happen if there are no album images?
                return
            }
            
            let cccAlbum = CCCAlbum(name: album.name,
                                    coverUrl: albumImages[0].url,
                                    uri: album.uri!)
            
            currentTrack = CCCTrack(name: trackName,
                                    artist: artists[0].name,
                                    album: cccAlbum,
                                    uri: uri)
            print(currentTrack)
        }
    }
    
    func getAuthUrl() -> URL {
        // from https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/Model/Spotify.swift
        
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
                .userReadCurrentlyPlaying,
                .userModifyPlaybackState
            ]
        )!
        
        return authUrl!
    }
    
    func handleURL(_ url: URL) {
        // from https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/Model/Spotify.swift
        
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
            if case .failure(let error) = completion {
                print("Couldn't retrieve access and refresh tokens:\n\(error)")
                
                let alertTitle: String
                let alertMessage: String
                
                if let authError = error as? SpotifyAuthorizationError,
                   authError.accessWasDenied {
                    alertTitle = "You denied the authorization request. "
                    alertMessage = ""
                } else {
                    alertTitle =
                    "Couldn't authorize your account."
                    alertMessage = error.localizedDescription
                }
                
                print(alertTitle)
                print(alertMessage)
            }
            
            // update the authorization state inside this scope instead of the function scope so this is only updated once the authorization actually succeeds
            self.updatePlayback()
            self.isAuthorized = true
        })
        .store(in: &cancellables)
        
        authorizationState = String.randomURLSafe(length: 128)
        
        isAuthorized = true
    }
    
    func updatePlayback() {
        /**
         Makes a call to the Spotify API to fetch the currently played track. Updated internally by first setting the `Track recentTrack` to its value, which gets fixed by the didSet to conform to `CCCTrack
         */
        
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
                    // TODO: handle podcast episodes.
                    self.recentTrack = nil
                }
                
            })
            .store(in: &cancellables)
    }
    
    func pauseCurrentPlayback() {
        // TODO: this breaks when you give input through the regular Spotify app or through the web UI
        self.updatePlayback()
        if self.isPlaying {
            print("Pausing playback...")
            spotify.pausePlayback().receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error Pausing Playback: \(error.localizedDescription)")
                    }
                })
                .store(in: &cancellables)
        } else {
            print("Resuming playback...")
            spotify.resumePlayback().receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error Resuming Playback: \(error.localizedDescription)")
                    }
                })
                .store(in: &cancellables)
        }
        
        self.isPlaying = !self.isPlaying
        
    }
    
    func skipPlayback() {
        spotify.skipToNext().receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error Pausing Playback: \(error.localizedDescription)")
                }
                self.updatePlayback()
                self.isPlaying = true
            })
            .store(in: &cancellables)
    }
    
    func skipToPreviousPlayback() {
        spotify.skipToPrevious().receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error Pausing Playback: \(error.localizedDescription)")
                }
                self.updatePlayback()
                self.isPlaying = true
            })
            .store(in: &cancellables)
    }
    
}
