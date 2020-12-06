//
//  DiscoverAPIs.swift
//  
//
//  Created by Breno Aquino on 11/07/20.
//

import Foundation
import Moya

enum DiscoverAPIs {
    case discoverMovie(config: MovieDBConfig, genre: Int)
}

extension DiscoverAPIs: TargetType {
    
    var baseURL: URL {
        switch self {
        case .discoverMovie(let config, _):
            return try! config.baseURL.asURL()
        }
    }
    
    var path: String {
        switch self {
        case .discoverMovie(let config, _):
            return config.path("/discover/movie")
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .discoverMovie:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .discoverMovie(let config, let genre):
            let params: [String: Any] = ["language": "pt-br", "api_key": config.apiKey, "with_genres": genre]
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
