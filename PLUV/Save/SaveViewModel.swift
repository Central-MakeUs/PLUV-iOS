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
    var selectSaveItem: Observable<Feed>?
    var saveItems: Observable<[Feed]> = Observable.just([])
}
