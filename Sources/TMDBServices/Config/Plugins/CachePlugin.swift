//
//  File.swift
//  
//
//  Created by Breno Aquino on 11/07/20.
//

import Foundation
import Moya

public protocol CachePolicyAPI {
    var cachePolicy: URLRequest.CachePolicy? { get }
}

class CachePlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let moyaCachePolicy = target as? CachePolicyAPI {
            var cachableRequest = request
            cachableRequest.cachePolicy = moyaCachePolicy.cachePolicy ?? .reloadIgnoringLocalCacheData
            return cachableRequest
        }
        
        var requestWitoutCache = request
        requestWitoutCache.cachePolicy = .reloadIgnoringLocalCacheData
        return requestWitoutCache
    }
}
