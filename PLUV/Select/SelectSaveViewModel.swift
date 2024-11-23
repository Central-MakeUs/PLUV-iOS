//
//  SelectSaveViewModel.swift
//  PLUV
//
//  Created by jaegu park on 11/9/24.
//

import Foundation
import RxSwift
import RxCocoa

class SelectSaveViewModel {
   var saveItem: Feed?
   var musicItem = BehaviorRelay<[Music]>(value: [])
   let selectedMusic = BehaviorRelay<[Music]>(value: [])
   let disposeBag = DisposeBag()
   
   func musicItemCount(completion: @escaping (Int) -> Void)  {
      musicItem
         .map { $0.count }
         .subscribe(onNext: { count in
            completion(count)
         })
         .disposed(by: disposeBag)
   }
   
   func musicSelect(music: Music) {
      var currentSelect = selectedMusic.value
      
      if let index = currentSelect.firstIndex(where: { $0.title == music.title && $0.artistNames == music.artistNames }) {
         currentSelect.remove(at: index)
      } else {
         currentSelect.append(music)
      }
      
      selectedMusic.accept(currentSelect)
   }
}
