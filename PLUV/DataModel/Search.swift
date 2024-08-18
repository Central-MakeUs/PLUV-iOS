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

struct SearchMusic: Codable {
    let id: String?
    let title: String
    let artistName: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, title, artistName
        case imageURL = "imageUrl"
    }
}
