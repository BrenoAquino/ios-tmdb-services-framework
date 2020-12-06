//
//  MovieNetwork.swift
//  
//
//  Created by Breno Aquino on 11/07/20.
//

import Foundation

class MovieNetwork {
    
    private var network: Network<MovieAPIs>
    private var config: MovieDBConfig
    
    init() {
        network = Network<MovieAPIs>()
        config = MovieDBConfig(version: .v3)
    }
    
    func upcoming(callback: @escaping (Result<[Movie], TMDBError>) -> Void) {
        network.request(MovieAPIs.upcoming(config: config)) { result in
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
    
    func detail(id: Int, callback: @escaping (Result<Movie, TMDBError>) -> Void) {
        network.request(MovieAPIs.detail(id: id, config: config)) { result in
            switch result {
            case .success(let response):
                do {
                    let movies = try response.map(Movie.self, using: JSONDecoder(), failsOnEmptyData: false)
                    callback(.success(movies))
                } catch let error {
                    callback(.failure(TMDBError(error)))
                }
                
            case .failure(let error):
                callback(.failure(TMDBError(error)))
            }
        }
    }
    
    func keywords(id: Int, callback: @escaping (Result<[Keyword], TMDBError>) -> Void) {
        network.request(MovieAPIs.keywords(id: id, config: config)) { result in
            switch result {
            case .success(let response):
                do {
                    let movies = try response.map([Keyword].self, atKeyPath: "keywords", using: JSONDecoder(), failsOnEmptyData: false)
                    callback(.success(movies))
                } catch let error {
                    callback(.failure(TMDBError(error)))
                }
                
            case .failure(let error):
                callback(.failure(TMDBError(error)))
            }
        }
    }
    
    func recommendations(id: Int, callback: @escaping (Result<[Movie], TMDBError>) -> Void) {
        network.request(MovieAPIs.recommendations(id: id, config: config)) { result in
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
