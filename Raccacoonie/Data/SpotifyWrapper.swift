
import SwiftUI

struct SpotifyWrapper {
    static func all() -> [CCCTrack] {
        let albums = [
            CCCAlbum(name: "Circles", coverUrl: URL(string: "https://i.scdn.co/image/ab67616d00001e028cbe65eb023c2f2b5cdf5a91")!, uri: "https://open.spotify.com/album/1YZ3k65Mqw3G8FzYlW1mmp?si=KDyLyuEbSLOQbpte86HZ0w"),
            CCCAlbum(name: "Vampire Weekend", coverUrl: URL(string: "https://i.scdn.co/image/ab67616d00001e028cbe65eb023c2f2b5cdf5a91")!, uri: "https://open.spotify.com/album/1YZ3k65Mqw3G8FzYlW1mmp?si=KDyLyuEbSLOQbpte86HZ0w")
        ]
        
        let samples = [
            CCCTrack(name: "Blue World", artist: "Mac Miller", album: albums[0], uri: "https://open.spotify.com/track/2Fii5F4XnVdWmWEVneqzLy?si=63eb391c8b1a4b6e"),
            CCCTrack(name: "Walcott", artist: "Vampire Weekend", album: albums[1], uri: "https://open.spotify.com/track/2Fii5F4XnVdWmWEVneqzLy?si=63eb391c8b1a4b6e")
        ]
        
        return samples
    }
    
    static func random() -> CCCTrack {
        return all().randomElement()!
    }

    
}
