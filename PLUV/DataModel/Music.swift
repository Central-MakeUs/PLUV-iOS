//
//  SpotifyMusic.swift
//  PLUV
//
//  Created by 백유정 on 8/15/24.
//

import Foundation

struct Music: Codable {
    let title: String
    let artistNames: String
    let isrcCode: String?
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case title, artistNames, isrcCode
        case imageURL = "imageUrl"
    }
}
