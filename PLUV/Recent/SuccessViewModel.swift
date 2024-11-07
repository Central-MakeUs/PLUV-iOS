//
//  SuccessViewModel.swift
//  PLUV
//
//  Created by jaegu park on 11/7/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SuccessViewModel {
    var selectSuccessItem: Observable<Music>?
    var successItems: Observable<[Music]> = Observable.just([])
}
