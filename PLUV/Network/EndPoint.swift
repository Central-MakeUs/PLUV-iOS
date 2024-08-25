//
//  EndPoint.swift
//  PLUV
//
//  Created by 백유정 on 8/8/24.
//

import Foundation

enum EndPoint {
    case loginApple
    case loginAppleAdd
    
    case playlistSpotifyRead
    case playlistMusicSpotifyRead(String)
    
    case playlistAppleRead
    case playlistAppleMusicRead(String)
    
    case musicAppleAdd
    case musicAppleSearch
    case musicSpotifyAdd
    case musicSpotifySearch
}

extension EndPoint {
    
    static let baseURL = "https://pluv.kro.kr"
    
    static func makeEndPoint(_ endpoint: String) -> String {
        baseURL + endpoint
    }
    
    var path: String {
        switch self {
        case .loginApple:
            return EndPoint.makeEndPoint("/login/apple")
        case .loginAppleAdd:
            return EndPoint.makeEndPoint("/login/apple/add")
        
        case .playlistSpotifyRead:
            return EndPoint.makeEndPoint("/playlist/spotify/read")
        case .playlistMusicSpotifyRead(let id):
            return EndPoint.makeEndPoint("/playlist/spotify/\(id)/read")
        
        case .playlistAppleRead:
            return EndPoint.makeEndPoint("/playlist/apple/read")
        case .playlistAppleMusicRead(let id):
            return EndPoint.makeEndPoint("/playlist/apple/\(id)/read")
            
            
        case .musicAppleAdd:
            return EndPoint.makeEndPoint("/music/apple/add")
        case .musicAppleSearch:
            return EndPoint.makeEndPoint("/music/apple/search")
        case .musicSpotifyAdd:
            return EndPoint.makeEndPoint("/music/spotify/add")
        case .musicSpotifySearch:
            return EndPoint.makeEndPoint("/music/spotify/search")
        }
    }
}
