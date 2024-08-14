//
//  SpotifyPlaylist.swift
//  PLUV
//
//  Created by 백유정 on 8/7/24.
//

import Foundation

struct SpotifyPlaylist: Codable {
    let id: String
    let thumbnailURL: String
    let songCount: Int
    let name: String
    let source: Source

    enum CodingKeys: String, CodingKey {
        case id
        case thumbnailURL = "thumbNailUrl"
        case songCount, name, source
    }
}

enum Source: String, Codable {
    case spotify
}
