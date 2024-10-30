//
//  FeedInfo.swift
//  PLUV
//
//  Created by 백유정 on 9/17/24.
//

import Foundation

struct FeedInfo: Codable {
    let id, songCount: Int
    let title, imageURL, creatorName: String
    let isBookMarked: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, songCount, title
        case imageURL = "imageUrl"
        case creatorName, isBookMarked, createdAt
    }
}
