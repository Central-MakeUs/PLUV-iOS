//
//  Me.swift
//  PLUV
//
//  Created by jaegu park on 10/21/24.
//

import Foundation

struct Me: Codable {
   let id: Int
   let transferredAt: String
   let transferredSongCount: Int
   let title: String
   let imageURL: String
   
   enum CodingKeys: String, CodingKey {
      case id, transferredAt, transferredSongCount, title
      case imageURL
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.id = try container.decode(Int.self, forKey: .id)
      self.transferredAt = try container.decode(String.self, forKey: .transferredAt)
      self.transferredSongCount = try container.decode(Int.self, forKey: .transferredSongCount)
      self.title = try container.decode(String.self, forKey: .title)
      self.imageURL = try container.decode(String.self, forKey: .imageURL)
   }
}
