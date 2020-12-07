//
//  GenreAPIs.swift
//  
//
//  Created by Breno Aquino on 11/07/20.
//

import Foundation
import Moya

enum GenreAPIs {
    case genres(config: MovieDBConfig)
}

extension GenreAPIs: TargetType {
    
    var baseURL: URL {
        switch self {
        case .genres(let config):
            return try! config.baseURL.asURL()
        }
    }
    
    var path: String {
        switch self {
        case .genres(let config):
            return config.path("/genre/movie/list")
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .genres:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .genres(let config):
            let params: [String: Any] = ["language": "pt-br", "api_key": config.apiKey]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
