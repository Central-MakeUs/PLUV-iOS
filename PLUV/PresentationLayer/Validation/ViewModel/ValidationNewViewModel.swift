//
//  ValidationNewViewModel.swift
//  PLUV
//
//  Created by jaegu park on 12/11/24.
//

import UIKit
import RxSwift
import RxCocoa

class NewViewModel {
    var successArr = BehaviorRelay<[SearchMusic]>(value: [])
    var musicItem = BehaviorRelay<[SearchMusic]>(value: [])
    var selectedMusic = BehaviorRelay<[SearchMusic]>(value: [])
    
    var completeArr: [String] = []
    
    var sections: Observable<[MusicSection]> {
        Observable.combineLatest(successArr, musicItem) { success, music in
            var combinedSections: [MusicSection] = []
            let maxCount = max(success.count, music.count)
            
            for i in 0..<maxCount {
                let successItem = i < success.count ? MusicSectionItem.success(success[i]) : nil
                let musicItem = i < music.count ? MusicSectionItem.music(music[i]) : nil
                
                var items: [MusicSectionItem] = []
                if let successItem = successItem {
                    items.append(successItem)
                }
                if let musicItem = musicItem {
                    items.append(musicItem)
                }
                
                combinedSections.append(MusicSection(header: "Section \(i + 1)", items: items))
            }
            return combinedSections
        }
    }
}
