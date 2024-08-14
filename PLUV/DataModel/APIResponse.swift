//
//  APIResponse.swift
//  PLUV
//
//  Created by 백유정 on 8/15/24.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let code: Int
    let msg: String
    let data: T
}
