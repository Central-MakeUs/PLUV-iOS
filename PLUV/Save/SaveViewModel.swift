//
//  SaveViewModel.swift
//  PLUV
//
//  Created by jaegu park on 11/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SaveViewModel {
   var selectSaveMusicItem = BehaviorRelay<[Music]>(value: [])
   var selectSaveItem: Feed?
   var saveItems: Observable<[Feed]> = Observable.just([])
}
