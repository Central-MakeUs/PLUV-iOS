//
//  History.swift
//  PLUV
//
//  Created by jaegu park on 10/21/24.
//

import Foundation

struct Recent: Codable {
   let id: Int
   let transferredAt: String
   let transferredSongCount: Int?
   let title: String
   let imageURL: String
   
   enum CodingKeys: String, CodingKey {
      case id, transferredAt, transferredSongCount, title
      case imageURL = "imageUrl"
   }
}
