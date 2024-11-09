//
//  SaveViewModel.swift
//  PLUV
//
//  Created by jaegu park on 11/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SaveViewModel {
   let selectedIndexPath = BehaviorRelay<IndexPath?>(value: nil)
   var selectSaveItem: Observable<Feed>?
   var saveItems: Observable<[Feed]> = Observable.just([])
   var saveItem: Feed = Feed(id: 0, title: "", thumbNailURL: "", artistNames: "", creatorName: "", transferredAt: "", totalSongCount: nil)
}
