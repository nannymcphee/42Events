//
//  NetworkManager.swift
//  42Events
//
//  Created by Nguyên Duy on 19/05/2021.
//

import Alamofire

fileprivate let baseUrl: String = "https://api-v2-sg-staging.42race.com/api/v1"

enum NetworkError: Error {
    case failed
}

class NetworkManager {
    static var shared = NetworkManager()
    
    typealias apiSuccess = (_ result: [String: Any]) -> Void
    typealias apiFailure = (_ errorMessage: String?) -> Void
    
    public func get(_ path: String, parameters: [String: Any]?, completion: @escaping (Result<[String: Any], NetworkError>) -> Void) {
        AF.request(baseUrl + path, parameters: parameters).responseJSON { (responseObject) in
            
            switch responseObject.result {
            case .success(let data):
                if let dict = data as? [String: Any] {
                    completion(.success(dict))
                }
            case .failure(let error):
                print("API call failed with error: \(error.localizedDescription)")
                completion(.failure(.failed))
            }
        }
    }
}
