//
//  NetworkHelperConstants.swift
//  Movie.1
//
//  Created by Мария Аверина on 13.09.2022.
//

import Foundation

struct NetworkHelperConstants {
    static let apiKey = "be8ef21a1603bea092f25169f28bce3c"
    static let baseURL = "https://api.themoviedb.org/"
    static let moviesListURL = baseURL + "3/movie/" + "upcoming" + "?api_key=\(apiKey)"
    static let movieDetailURL = baseURL + "3/movie/"
    
}


