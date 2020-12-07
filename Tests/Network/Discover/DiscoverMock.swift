//
//  DiscoverMock.swift
//  
//
//  Created by Breno Aquino on 27/10/20.
//

import Foundation
import Moya
import TMDBServices

enum DiscoverMock {
    static let discoverSuccess = { (target: Moya.TargetType) -> Endpoint in
        let data = Mock.shared.dataFromJson("discover-28-success")
        return Endpoint(
            url: target.baseURL.appendingPathComponent(target.path).absoluteString,
            sampleResponseClosure: { .networkResponse(200, data) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
    }
    
    static let discoverGenericError = { (target: Moya.TargetType) -> Endpoint in
        let data = Mock.shared.dataFromJson("discover-28-failure")
        return Endpoint(
            url: target.baseURL.appendingPathComponent(target.path).absoluteString,
            sampleResponseClosure: { .networkResponse(400, data) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
    }
    
    static let discoverMapError = { (target: Moya.TargetType) -> Endpoint in
        let data = Mock.shared.dataFromJson("discover-28-map-error")
        return Endpoint(
            url: target.baseURL.appendingPathComponent(target.path).absoluteString,
            sampleResponseClosure: { .networkResponse(200, data) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
    }
    
    static let discoverEmpty = { (target: Moya.TargetType) -> Endpoint in
        let data = Mock.shared.dataFromJson("discover-28-empty")
        return Endpoint(
            url: target.baseURL.appendingPathComponent(target.path).absoluteString,
            sampleResponseClosure: { .networkResponse(200, data) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
    }
}
