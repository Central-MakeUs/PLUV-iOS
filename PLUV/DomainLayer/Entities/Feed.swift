//
//  Feed.swift
//  PLUV
//
//  Created by 백유정 on 8/31/24.
//

import Foundation

struct Feed: Codable {
    let id: Int
    let title: String
    let thumbNailURL: String
    let artistNames: String
    let creatorName: String
    let transferredAt: String
    let totalSongCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, title
        case thumbNailURL = "thumbNailUrl"
        case artistNames, creatorName, transferredAt, totalSongCount
    }
}
