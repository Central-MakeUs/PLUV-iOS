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
        }
    }
}
