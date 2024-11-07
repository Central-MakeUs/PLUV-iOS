//
//  SaveDetailViewModel.swift
//  PLUV
//
//  Created by jaegu park on 11/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SaveDetailViewModel {
    var selectSaveDetailItem: Observable<Music>?
    var saveDetailItems: Observable<[Music]> = Observable.just([])
}
