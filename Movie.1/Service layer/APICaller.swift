//
//  APICaller.swift
//  Movie.1
//
//  Created by Мария Аверина on 12.09.2022.
//

import Foundation
import Alamofire

final class APICaller {
    
    static let shared = APICaller()
    
    public func performAPICall<T: Decodable>(url: URL, expectingReturnType: T.Type, completion: @escaping ((T) -> Void)) {
        AF.request(url).responseDecodable { (response: AFDataResponse<T>) in
            switch response.result {
            case.success(let value):
                completion(value)
            case .failure(let error):
                print(error)
            }
        }
    }
}
