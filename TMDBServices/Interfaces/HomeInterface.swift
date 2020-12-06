//
//  HomeInterface.swift
//  
//
//  Created by Breno Aquino on 11/07/20.
//

import Foundation

public class HomeInterface {
    
    public struct HomeResult {
        var genres: [Genre]? = nil
        var upcomings: [Movie]? = nil
        var moviesByGenre: [Int: [Movie]?] = [:]
    }
    
    // MARK: Network Interfaces
    private let genreNetwork: GenreNetwork
    private let discoverNetwork: DiscoverNetwork
    private let movieNetwork: MovieNetwork
    
    // MARK: - Life Cycle
    public init() {
        genreNetwork = GenreNetwork()
        discoverNetwork = DiscoverNetwork()
        movieNetwork = MovieNetwork()
    }
    
    // MARK: - Network Methods
    private func getUpcoming(group: DispatchGroup?, callback: @escaping (Result<[Movie], TMDBError>) -> Void) {
        group?.enter()
        movieNetwork.upcoming { result in
            callback(result)
            group?.leave()
        }
    }
    
    private func getGenres(group: DispatchGroup?, callback: @escaping (Result<[Genre], TMDBError>) -> Void) {
        group?.enter()
        genreNetwork.genres { result in
            callback(result)
            group?.leave()
        }
    }
    
    private func getMovies(group: DispatchGroup?, genre: Genre, callback: @escaping (Result<[Movie], TMDBError>) -> Void) {
        group?.enter()
        discoverNetwork.movies(genre: genre.id) { result in
            callback(result)
            group?.leave()
        }
    }
    
    // MARK: - Interfaces
    public func home(callback: @escaping (Result<HomeResult, TMDBError>) -> Void) {
        var homeResult: HomeResult = HomeResult()
        var error: TMDBError? = nil
        
        let group = DispatchGroup()
        getUpcoming(group: group) { $0.unwrapper(&homeResult.upcomings, &error) }
        getGenres(group: group) { result in
            result.unwrapper(&homeResult.genres, &error)
            homeResult.genres?.forEach { [weak self] genre in
                self?.getMovies(group: group, genre: genre, callback: { result in
                    if case .success(let model) = result {
                        homeResult.moviesByGenre[genre.id] = model
                    }
                })
            }
        }
        
        group.notify(queue: .global()) {
            if let error = error {
                callback(.failure(error))
            } else {
                callback(.success(homeResult))
            }
        }
    }
}
