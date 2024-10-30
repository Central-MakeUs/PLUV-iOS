//
//  RecentViewModel.swift
//  PLUV
//
//  Created by jaegu park on 10/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class RecentViewModel {
    var selectRecentItem: Observable<Recent>?
    var recentItems: Observable<[Recent]> = Observable.just([])
}
