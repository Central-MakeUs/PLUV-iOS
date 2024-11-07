//
//  History.swift
//  PLUV
//
//  Created by jaegu park on 11/7/24.
//

import Foundation

struct HistoryInfo: Codable {
   let id: Int
   let transferredAt: String
   let totalSongCount: Int
   let title: String
   let imageURL: String
   
   enum CodingKeys: String, CodingKey {
      case id, transferredAt, totalSongCount, title
      case imageURL = "imageURL"
   }
}
