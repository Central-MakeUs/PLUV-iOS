//
//  FeedViewModel.swift
//  PLUV
//
//  Created by 백유정 on 8/31/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FeedViewModel {
    // 선택된 셀의 인덱스 패스를 저장하는 BehaviorRelay
    let selectedIndexPath = BehaviorRelay<IndexPath?>(value: nil)
    var feedItems: Observable<[Feed]> = Observable.just([])
}
