//
//  SelectSavePlaylistViewModel.swift
//  PLUV
//
//  Created by jaegu park on 11/13/24.
//

import Foundation
import RxSwift
import RxCocoa

class SelectSavePlaylistViewModel {
   // 선택된 셀의 인덱스 패스를 저장하는 BehaviorRelay
   let selectedIndexPath = BehaviorRelay<IndexPath?>(value: nil)
   var savePlaylistItems: Observable<[Feed]> = Observable.just([])
   var savePlaylistItem: Feed?
}
