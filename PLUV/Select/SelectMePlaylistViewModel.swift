//
//  SelectMePlaylistViewModel.swift
//  PLUV
//
//  Created by jaegu park on 11/13/24.
//

import Foundation
import RxSwift
import RxCocoa

class SelectMePlaylistViewModel {
    // 선택된 셀의 인덱스 패스를 저장하는 BehaviorRelay
    let selectedIndexPath = BehaviorRelay<IndexPath?>(value: nil)
    var mePlaylistItems: Observable<[Me]> = Observable.just([])
    var mePlaylistItem: Me = Me(id: 0, transferredAt: "", transferredSongCount: nil, title: "", imageURL: "")
}
