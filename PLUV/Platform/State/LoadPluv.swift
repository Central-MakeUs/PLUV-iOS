//
//  LoadPluv.swift
//  PLUV
//
//  Created by jaegu park on 10/30/24.
//

import Foundation

enum LoadPluv: Int, CaseIterable, Codable {
    case FromRecent
    case FromSave
    
    var name: String {
        switch self {
        case .FromRecent:
            "최근 옮긴 항목"
        case .FromSave:
            "저장한 플레이리스트"
        }
    }
    
    var icon: String {
        switch self {
        case .FromRecent:
            "recent_icon"
        case .FromSave:
            "save_icon"
        }
    }
    
    var iconSelect: String {
        icon + "_select"
    }
}
