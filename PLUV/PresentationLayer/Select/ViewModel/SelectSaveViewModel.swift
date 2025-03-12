//
//  SelectSaveViewModel.swift
//  PLUV
//
//  Created by jaegu park on 11/9/24.
//

import Foundation
import RxSwift
import RxCocoa

class SelectSaveViewModel: SelectMusicViewModelProtocol {
   var saveItem: Feed?
   var musicItem = BehaviorRelay<[Music]>(value: [])
   let selectedMusic = BehaviorRelay<[Music]>(value: [])
   let disposeBag = DisposeBag()
}
