//
//  MovieModel.swift
//  Movie.1
//
//  Created by Мария Аверина on 17.12.2021.
//

import Foundation

struct MovieResponse: Decodable {
   
    let dates: Movie
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Movie: Decodable {
    let maximum, minimum: String
}

// MARK: - Result
struct Result: Decodable { 
    let backdropPath: String?
    let id: Int
    let originalLanguage: String
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    var poster: String? {
        get{
            return "https://image.tmdb.org/t/p/w500/\(posterPath)"
        }
    }
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    var posterImageData: Data?

    enum CodingKeys: String, CodingKey {

        case backdropPath = "backdrop_path"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


