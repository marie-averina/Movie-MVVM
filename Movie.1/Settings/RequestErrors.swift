//
//  RequestErrors.swift
//  Movie.1
//
//  Created by Мария Аверина on 24.09.2022.
//

import Foundation


enum RequestErrors: String, Error {
    case invalidURLError = "Url request failed"
    case URLRequestFailed = "Invalid url"
    case imageFailedToLoad = "Image failed to load"
}

