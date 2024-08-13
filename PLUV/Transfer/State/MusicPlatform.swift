//
//  MusicPlatform.swift
//  PLUV
//
//  Created by 백유정 on 7/31/24.
//

import Foundation

enum MusicPlatform: Int, CaseIterable, Codable {
    case AppleMusic
    case Spotify
    case YoutubeMusic
    
    var name: String {
        switch self {
        case .AppleMusic:
            "애플뮤직"
        case .Spotify:
            "스포티파이"
        case .YoutubeMusic:
            "유튜브뮤직"
        }
    }
    
    var icon: String {
        switch self {
        case .AppleMusic:
            "applemusic_icon"
        case .Spotify:
            "spotify_icon"
        case .YoutubeMusic:
            "youtubemusic_icon"
        }
    }
    
    var iconSelect: String {
        icon + "_select"
    }
}
