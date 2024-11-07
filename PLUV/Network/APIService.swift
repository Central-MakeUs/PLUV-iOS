//
//  APIService.swift
//  PLUV
//
//  Created by 백유정 on 8/8/24.
//

import UIKit
import Alamofire

struct APIService {
    
    static var shared = APIService()
    var loginAccessTokenKey = "loginAccessTokenKey"
    
    func get<T: Codable>(of type: T.Type, url: URLConvertible, success: @escaping (T) -> (), failure: ((Error) -> ())? = nil) {
        
        let headers: HTTPHeaders = ["Content-Type":"application/json", "Accept":"application/json"]
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .responseDecodable(of: type) { response in
            
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                if let failure = failure {
                    failure(error)
                } else {
                    AlertController(message: error.localizedDescription).show()
                }
            }
        }
    }
   
   func getWithAccessToken<T: Codable>(of type: T.Type, url: URLConvertible, AccessToken: String, success: @escaping (T) -> (), failure: ((Error) -> ())? = nil) {
       
       let headers: HTTPHeaders = ["Content-Type":"application/json", "Accept":"application/json",
           "Authorization" : "Bearer \(AccessToken)"]
       
       AF.request(url,
                  method: .get,
                  encoding: JSONEncoding(options: []),
                  headers: headers)
       .responseDecodable(of: type) { response in
           
           switch response.result {
           case .success(let value):
               success(value)
           case .failure(let error):
               if let failure = failure {
                   failure(error)
               } else {
                   AlertController(message: error.localizedDescription).show()
               }
           }
       }
   }
    
    func post<T: Codable>(of type: T.Type, url: URLConvertible, parameters: [String : Any], success: @escaping (T) -> (), failure: ((Error) -> ())? = nil) {
        
        let headers: HTTPHeaders = ["Content-Type":"application/json", "Accept":"application/json"]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .responseDecodable(of: type) { response in
            
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                if let failure = failure {
                    failure(error)
                } else {
                    AlertController(message: error.localizedDescription).show()
                }
            }
        }
    }
    
    func postWithAccessToken<T: Codable>(of type: T.Type, url: URLConvertible, parameters: [String : Any]?, AccessToken: String, success: @escaping (T) -> (), failure: ((Error) -> ())? = nil) {
        
        let headers: HTTPHeaders = ["Content-Type":"application/json",
                                    "Accept":"application/json",
                                    "Authorization" : "Bearer \(AccessToken)"]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .responseDecodable(of: type) { response in
            
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                if let failure = failure {
                    failure(error)
                } else {
                    AlertController(message: error.localizedDescription).show()
                }
            }
        }
    }
}
