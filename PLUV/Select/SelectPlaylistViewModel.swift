//
//  TransferPlaylistViewModel.swift
//  PLUV
//
//  Created by 백유정 on 8/14/24.
//

import UIKit
import RxSwift
import RxCocoa

class SelectPlaylistViewModel {
    // 선택된 셀의 인덱스 패스를 저장하는 BehaviorRelay
    let selectedIndexPath = BehaviorRelay<IndexPath?>(value: nil)
    var playlistItems: Observable<[Playlist]> = Observable.just([])
    var playlistItem: Playlist?
}
