//
//  SelectMusicViewModel.swift
//  PLUV
//
//  Created by 백유정 on 8/15/24.
//

import Foundation
import RxSwift
import RxCocoa

class SelectMusicViewModel {
    var musicItem: Observable<[Music]> = Observable.just([])
}
