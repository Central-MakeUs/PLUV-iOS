//
//  MoveMeViewModel.swift
//  PLUV
//
//  Created by jaegu park on 11/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class MoveMeViewModel {
   var meItem: Me = Me(id: 0, transferredAt: "", transferredSongCount: nil, title: "", imageURL: "")
   var musicItems: [Music] = []
}
