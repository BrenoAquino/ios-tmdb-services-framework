//
//  Movie.swift
//  
//
//  Created by Breno Aquino on 11/07/20.
//

import Foundation

public struct Movie: Codable {
    public let popularity: Double?
    public let voteCount: Int?
    public let hasVideo: Bool?
    public let poster: String?
    public let id: Int?
    public let adult: Bool?
    public let backdrop: String?
    public let originalLanguage: String?
    public let originalTitle: String?
    public let genreIDs: [Int]?
    public let title: String?
    public let voteAverage: Double?
    public let overview: String?
    public let releaseDate: String?
    public let genres: [Genre]?
    
    public let budget: Int?
    public let homepage: String?
    public let imdbId: String?
    public let revenue: Int?
    public let runtime: Int?
    public let status: String?
    public let tagline: String?
    public let productionCompanies: [ProductCompany]?
    
    enum CodingKeys: String, CodingKey {
        case popularity, id, adult, title, overview, genres, budget, homepage, revenue, runtime, status, tagline
        case voteCount = "vote_count"
        case hasVideo = "video"
        case poster = "poster_path"
        case backdrop = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDs = "genre_ids"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case imdbId = "imdb_id"
        case productionCompanies = "production_companies"
    }
}
