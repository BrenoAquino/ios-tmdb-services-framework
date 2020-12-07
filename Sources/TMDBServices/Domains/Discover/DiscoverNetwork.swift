//
//  DiscoverNetwork.swift
//  
//
//  Created by Breno Aquino on 11/07/20.
//

import Foundation

class DiscoverNetwork {
    
    private var network: Network<DiscoverAPIs>
    private var config: MovieDBConfig
    
    init() {
        network = Network<DiscoverAPIs>()
        config = MovieDBConfig(version: .v3)
    }
    
    func movies(genre: Int, callback: @escaping (Result<[Movie], TMDBError>) -> Void) {
        network.request(DiscoverAPIs.discoverMovie(config: config, genre: genre)) { result in
            switch result {
            case .success(let response):
                do {
                    let movies = try response.map([Movie].self, atKeyPath: "results", using: JSONDecoder(), failsOnEmptyData: false)
                    callback(.success(movies))
                } catch let error {
                    callback(.failure(TMDBError(error)))
                }
                
            case .failure(let error):
                callback(.failure(TMDBError(error)))
            }
        }
    }
}
