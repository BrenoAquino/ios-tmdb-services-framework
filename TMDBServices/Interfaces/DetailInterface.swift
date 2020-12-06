//
//  DetailInterface.swift
//  
//
//  Created by Breno Aquino on 11/07/20.
//

import Foundation

public class DetailInterface {
    
    public struct DetailResult {
        var movie: Movie? = nil
        var keywords: [Keyword]? = nil
        var recommendations: [Movie]? = nil
    }
    
    // MARK: Network Interfaces
    private let movieNetwork: MovieNetwork
    
    // MARK: - Life Cycle
    public init() {
        movieNetwork = MovieNetwork()
    }
    
    // MARK: - Network Methods
    public func getDetail(group: DispatchGroup?, id: Int, callback: @escaping (Result<Movie, TMDBError>) -> Void) {
        group?.enter()
        movieNetwork.detail(id: id) { result in
            callback(result)
            group?.leave()
        }
    }
    
    public func getKeywords(group: DispatchGroup?, id: Int, callback: @escaping (Result<[Keyword], TMDBError>) -> Void) {
        group?.enter()
        movieNetwork.keywords(id: id) { result in
            callback(result)
            group?.leave()
        }
    }
    
    public func getRecommendations(group: DispatchGroup?, id: Int, callback: @escaping (Result<[Movie], TMDBError>) -> Void) {
        group?.enter()
        movieNetwork.recommendations(id: id) { result in
            callback(result)
            group?.leave()
        }
    }
    
    // MARK: - Interfaces
    public func detail(id: Int, callback: @escaping (Result<DetailResult, TMDBError>) -> Void) {
        var detailResult: DetailResult = DetailResult()
        var error: TMDBError? = nil
        
        let group = DispatchGroup()
        getDetail(group: group, id: id) { $0.unwrapper(&detailResult.movie, &error) }
        getKeywords(group: group, id: id) { $0.unwrapper(&detailResult.keywords, &error) }
        getRecommendations(group: group, id: id) { $0.unwrapper(&detailResult.recommendations, &error)  }
        
        group.notify(queue: .global()) {
            if let error = error {
                callback(.failure(error))
            } else {
                callback(.success(detailResult))
            }
        }
    }
}
