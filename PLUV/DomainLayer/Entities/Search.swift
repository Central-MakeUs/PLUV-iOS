//
//  SearchMusic.swift
//  PLUV
//
//  Created by 백유정 on 8/19/24.
//

import Foundation

struct Search: Codable {
    let isEqual: Bool
    let isFound: Bool
    let sourceMusic: SearchMusic
    let destinationMusics: [SearchMusic]
}

struct SearchMusic: Codable, Equatable {
    let id: String?
    let title: String
    let artistName: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, title, artistName
        case imageURL = "imageUrl"
    }
    
    static func == (lhs: SearchMusic, rhs: SearchMusic) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.artistName == rhs.artistName &&
        lhs.imageURL == rhs.imageURL
    }
}
