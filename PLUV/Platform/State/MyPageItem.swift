//
//  MyPageItem.swift
//  PLUV
//
//  Created by 백유정 on 8/30/24.
//

import Foundation

enum MyPageItem: Int, CaseIterable {
    case Inquiry
    case TermsOfService
    case PrivacyPolicy
    case LogOut
    
    var text: String {
        switch self {
        case .Inquiry:
            "1:1 문의"
        case .TermsOfService:
            "서비스 이용 약관"
        case .PrivacyPolicy:
            "개인정보처리방침"
        case .LogOut:
            "로그아웃"
        }
    }
}
