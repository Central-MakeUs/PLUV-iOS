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
    var selectFeedMusicItem = BehaviorRelay<[Music]>(value: [])
    var selectFeedItem: Feed?
    var feedItems: Observable<[Feed]> = Observable.just([])
}
