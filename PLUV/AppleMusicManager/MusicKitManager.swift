//
//  MusicKitManager.swift
//  PLUV
//
//  Created by 백유정 on 8/16/24.
//

import Foundation
import MusicKit

class MusicKitManager {
    
    static let shared = MusicKitManager()
    private init() { }
    
    func fetchMusic(_ txt: String) {
        Task {
            // Request permission
            let status = await MusicAuthorization.request()

            switch status {
            case .authorized:
                // Request -> Response
                do {
                    var request = MusicCatalogSearchRequest(term: txt, types: [Song.self])
                    request.limit = 25
                    request.offset = 1
                    
                    let result = try await request.response()

                    print(result)
                } catch {
                    print(String(describing: error))
                }
            default:
                break;
            }
        }
    }
}
