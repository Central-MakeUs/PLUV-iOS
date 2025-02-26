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
   var selectMeMusicItem = BehaviorRelay<[Music]>(value: [])
   var selectMeItem: Me?
   var meItems: Observable<[Me]> = Observable.just([])
}
