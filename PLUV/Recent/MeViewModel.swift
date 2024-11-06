//
//  MeViewModel.swift
//  PLUV
//
//  Created by jaegu park on 10/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MeViewModel {
    var selectMeItem: Observable<Me>?
    var MeItems: Observable<[Me]> = Observable.just([])
}
