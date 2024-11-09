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
   let selectedIndexPath = BehaviorRelay<IndexPath?>(value: nil)
   var selectMeItem: Observable<Me>?
   var meItems: Observable<[Me]> = Observable.just([])
   var meItem: Me = Me(id: 0, transferredAt: "", transferredSongCount: nil, title: "", imageURL: "")
}
