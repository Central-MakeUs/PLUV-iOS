//
//  MoveSaveViewModel.swift
//  PLUV
//
//  Created by jaegu park on 11/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class MoveSaveViewModel {
   var saveItem: Feed = Feed(id: 0, title: "", thumbNailURL: "", artistNames: "", creatorName: "", transferredAt: "", totalSongCount: nil)
   var musicItems: [Music] = []
}
