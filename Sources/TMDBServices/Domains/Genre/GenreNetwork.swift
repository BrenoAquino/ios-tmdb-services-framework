//
//  GenreNetwork.swift
//  
//
//  Created by Breno Aquino on 11/07/20.
//

import Foundation

class GenreNetwork {
    
    private var network: Network<GenreAPIs>
    private var config: MovieDBConfig
    
    init() {
        network = Network<GenreAPIs>()
        config = MovieDBConfig(version: .v3)
    }
    
    func genres(callback: @escaping (Result<[Genre], TMDBError>) -> Void) {
        network.request(GenreAPIs.genres(config: config)) { result in
            switch result {
            case .success(let response):
                do {
                    let genres = try response.map([Genre].self, atKeyPath: "genres", using: JSONDecoder(), failsOnEmptyData: false)
                    callback(.success(genres))
                } catch let error {
                    callback(.failure(TMDBError(error)))
                }
                
            case .failure(let error):
                callback(.failure(TMDBError(error)))
            }
        }
    }
}
