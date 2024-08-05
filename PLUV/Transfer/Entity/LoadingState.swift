//
//  LoadingState.swift
//  PLUV
//
//  Created by 백유정 on 8/1/24.
//

import Foundation

enum LoadingState: Int, CaseIterable {
    case LoadPlaylist
    case LoadMusic
    case SearchMusic
    
    var label: String {
        switch self {
        case .LoadPlaylist:
            "플레이리스트를\n불러오는 중이에요!"
        case .LoadMusic:
            "음악을\n불러오는 중이에요!"
        case .SearchMusic:
            "음악을\n찾는 중이에요!"
        }
    }
    
    var image: String {
        switch self {
        case .LoadPlaylist:
            "loadplaylist_image"
        case .LoadMusic:
            "loadmusic_image"
        case .SearchMusic:
            "searchmusic_image"
        }
    }
}
