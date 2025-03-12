//
//  ScreenShotPlaylistViewModel.swift
//  PLUV
//
//  Created by jaegu park on 1/23/25.
//

import UIKit
import RxSwift
import RxCocoa

class ScreenShotPlaylistViewModel : SelectMusicViewModelProtocol {
    var screenShotItem: Music?
    var musicItem = BehaviorRelay<[Music]>(value: [])
    let selectedMusic = BehaviorRelay<[Music]>(value: [])
    let disposeBag = DisposeBag()
}
