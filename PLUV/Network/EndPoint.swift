//
//  EndPoint.swift
//  PLUV
//
//  Created by 백유정 on 8/8/24.
//

import Foundation

enum EndPoint {
    case feed
    case feedId(String)
    case feedIdMusic(String)
    
    case loginApple
    case loginAppleAdd
    
    case memberUnregister
    
    case musicAppleAdd
    case musicAppleSearch
    case musicSpotifyAdd
    case musicSpotifySearch
    
    case playlistSpotifyRead
    case playlistMusicSpotifyRead(String)
    
    case playlistAppleRead
    case playlistAppleMusicRead(String)
    
    case inquiry
    case termsOfService
    case privacyPolicy
}

extension EndPoint {
    
    static let baseURL = "https://pluv.kro.kr"
    
    static func makeEndPoint(_ endpoint: String) -> String {
        baseURL + endpoint
    }
    
    var path: String {
        switch self {
        case .feed:
            return EndPoint.makeEndPoint("/feed")
        case .feedId(let id):
            return EndPoint.makeEndPoint("/feed/\(id)")
        case .feedIdMusic(let id):
            return EndPoint.makeEndPoint("/feed/\(id)/music")
            
        case .loginApple:
            return EndPoint.makeEndPoint("/login/apple")
        case .loginAppleAdd:
            return EndPoint.makeEndPoint("/login/apple/add")
        
        case .memberUnregister:
            return EndPoint.makeEndPoint("/member/unregister")
            
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
            
        case .inquiry:
            return "https://walla.my/survey/ewFV6AO4W9HhXwM8ilWG"
        case .termsOfService:
            return EndPoint.makeEndPoint("/policy")
        case .privacyPolicy:
            return EndPoint.makeEndPoint("/personal")
        }
    }
}
