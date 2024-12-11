//
//  SectionOfMusic.swift
//  PLUV
//
//  Created by jaegu park on 12/11/24.
//

import RxDataSources

struct MusicSection {
    var header: String
    var items: [MusicSectionItem]
}

enum MusicSectionItem {
    case success(SearchMusic)
    case music(SearchMusic)
}

extension MusicSection: SectionModelType {
    init(original: MusicSection, items: [MusicSectionItem]) {
        self = original
        self.items = items
    }
}
