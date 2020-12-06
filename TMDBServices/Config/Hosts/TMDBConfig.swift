//
//  File.swift
//  
//
//  Created by Breno Aquino on 11/07/20.
//

import Foundation

public class MovieDBConfig: NSObject {
    var apiKey: String { TMDBServices.shared.apiKey }
    var baseURL: String { MovieDBConfig.baseURL }
    
    var version: Version?
    
    init(version: Version? = nil) {
        self.version = version
    }
    
    func path(_ path: String) -> String {
        if let version = version {
            return "\(version.rawValue)\(path)"
        }
        return path
    }
}

// MARK: - Static Vars
public extension MovieDBConfig {
    static let baseURL: String = "https://api.themoviedb.org/"
    static let baseImageURL: String = "https://image.tmdb.org/t/p/"
}
