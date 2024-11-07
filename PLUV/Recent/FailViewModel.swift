//
//  FailViewModel.swift
//  PLUV
//
//  Created by jaegu park on 11/7/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FailViewModel {
    var selectFailItem: Observable<Music>?
    var failItems: Observable<[Music]> = Observable.just([])
}
