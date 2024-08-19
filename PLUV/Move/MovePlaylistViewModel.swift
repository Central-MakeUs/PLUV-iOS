//
//  MovePlaylistViewModel.swift
//  PLUV
//
//  Created by 백유정 on 8/20/24.
//

import Foundation
import RxSwift
import RxCocoa

class MovePlaylistViewModel {
    var playlistItem: Playlist = Playlist(id: "", thumbnailURL: "", songCount: nil, name: "", source: .apple)
    var musicItems: [Music] = []
}
