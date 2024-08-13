//
//  EndPoint.swift
//  PLUV
//
//  Created by 백유정 on 8/8/24.
//

import Foundation

enum EndPoint {
    case playlistSpotifyRead
}

extension EndPoint {
    
    static let baseURL = "https://pluv.kro.kr"
    
    static func makeEndPoint(_ endpoint: String) -> String {
        baseURL + endpoint
    }
    
    var path: String {
        switch self {
        case .playlistSpotifyRead:
            return EndPoint.makeEndPoint("/playlist/spotify/read")
        }
    }
}
