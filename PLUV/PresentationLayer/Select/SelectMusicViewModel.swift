//
//  SelectMusicViewModel.swift
//  PLUV
//
//  Created by 백유정 on 8/15/24.
//

import Foundation
import RxSwift
import RxCocoa

class SelectMusicViewModel: SelectMusicViewModelProtocol {
    var playlistItem: Playlist?
    var musicItem = BehaviorRelay<[Music]>(value: [])
    let selectedMusic = BehaviorRelay<[Music]>(value: [])
    let disposeBag = DisposeBag()
}
