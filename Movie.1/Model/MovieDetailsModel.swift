//
//  MovieDetailsModel.swift
//  Movie.1
//
//  Created by Мария Аверина on 05.09.2022.
//

import Foundation

// MARK: - MovieDetailsModel

struct MovieDetailsModel: Decodable {
    var adult: Bool?
    var backdropPath: String?
    var budget: Int?
    var homepage: String?
    var id: Int?
    var imdbID, originalLanguage, originalTitle, overview: String?
    var popularity: Double?
    var posterPath: String
    var releaseDate: String?
    var revenue, runtime: Int?
    var status, tagline, title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    var poster: String? {
        get{
            return "https://image.tmdb.org/t/p/w500/\(posterPath)"
        }
    }
    var posterImageData: Data?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case revenue, runtime
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


