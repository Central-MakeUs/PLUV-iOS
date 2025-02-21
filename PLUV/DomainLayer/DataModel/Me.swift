//
//  Me.swift
//  PLUV
//
//  Created by jaegu park on 10/21/24.
//

import Foundation

struct Me: Codable {
   let id: Int
   let transferredDate: String
   let transferredSongCount: Int
   let title: String
   let imageURL: String
   
   enum CodingKeys: String, CodingKey {
      case id, transferredDate, transferredSongCount, title
      case imageURL = "imageUrl"
   }
}
