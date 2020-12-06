//
//  Network.swift
//  
//
//  Created by Breno Aquino on 11/07/20.
//

import Foundation
import Moya

class Network<TT: TargetType>: MoyaProvider<TT> {
    
    public init(plugins: [PluginType] = [], endpointClosure: @escaping (TT) -> Endpoint = MoyaProvider.defaultEndpointMapping) {
        var customPlugins: [PluginType] = plugins
        customPlugins.append(CachePlugin())
        
        if Mock.shared.isActive {
            super.init(stubClosure: MoyaProvider<TT>.delayedStub(0.2), plugins: customPlugins)
        } else {
            super.init(plugins: customPlugins)
        }
    }
    
    public override func endpoint(_ token: TT) -> Endpoint {
        if case .never = stubClosure(token) {
            return super.endpoint(token)
        }
        
        if let customEndpoint = Mock.shared.get(target: token) {
            return customEndpoint
        }
        return super.endpoint(token)
    }
}
