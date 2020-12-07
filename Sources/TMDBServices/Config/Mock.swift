//
//  Mock.swift
//  
//
//  Created by Breno Aquino on 27/10/20.
//

import Foundation
import Moya

extension TargetType {
    var sampleData: Data {
        return Data()
    }
    
    var hash: Int {
        var hasher = Hasher()
        hasher.combine(baseURL.hashValue)
        hasher.combine(path.hashValue)
        hasher.combine(method.hashValue)
        hasher.combine(headers?.hashValue)
        return hasher.finalize()
    }
}

public class Mock {
    public static let shared: Mock = Mock()
        
    var endToEndTests: Bool = false
    var isActive: Bool = false
    var bundleId: String = ""
    private var endpoints: [Int: ((TargetType) -> Endpoint)] = [:]
    
    // MARK: - Interfaces for Endpoints
    public func get(target: TargetType) -> Endpoint? {
        if let endpoint = endpoints[target.hash] {
            return endpoint(target)
        }
        return nil
    }
    
    public func add(target: TargetType, endpoint: @escaping ((TargetType) -> Endpoint)) {
        endpoints[target.hash] = endpoint
    }
    
    public func reset() {
        endpoints = [:]
    }
    
    // MARK: - Interfaces to get JSON file
    private func dataFromFile(name: String, `extension`: String) -> Data {
        if let file = Bundle(identifier: bundleId)?.url(forResource: name, withExtension: `extension`) {
            let json = try? String(contentsOf: file, encoding: .utf8)
            return json?.data(using: .utf8) ?? Data()
        }
        return "".data(using: .utf8) ?? Data()
    }
    
    public func dataFromJson(_ name: String) -> Data {
        return dataFromFile(name: name, extension: "json")
    }
}
