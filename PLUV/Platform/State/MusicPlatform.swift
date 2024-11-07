//
//  MusicPlatform.swift
//  PLUV
//
//  Created by 백유정 on 7/31/24.
//

import Foundation

protocol PlatformRepresentable {
    var name: String { get }
    var iconSelect: String { get }
}

enum MusicPlatform: Int, CaseIterable, Codable, PlatformRepresentable {
    case AppleMusic
    case Spotify
    
    var name: String {
        switch self {
        case .AppleMusic:
            "애플뮤직"
        case .Spotify:
            "스포티파이"
        }
    }
    
    var icon: String {
        switch self {
        case .AppleMusic:
            "applemusic_icon"
        case .Spotify:
            "spotify_icon"
        }
    }
    
    var iconSelect: String {
        icon + "_select"
    }
}

enum LoadPluv: Int, CaseIterable, Codable, PlatformRepresentable {
    case FromRecent
    case FromSave
    
    var name: String {
        switch self {
        case .FromRecent:
            "최근 옮긴 항목"
        case .FromSave:
            "저장한 플레이리스트"
        }
    }
    
    var icon: String {
        switch self {
        case .FromRecent:
            "recent_icon"
        case .FromSave:
            "save_icon"
        }
    }
    
    var iconSelect: String {
        icon + "_select"
    }
}

/*
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
 */
