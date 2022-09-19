//
//  MockAPIManager.swift
//  Movie.1Tests
//
//  Created by Мария Аверина on 12.09.2022.
//

import XCTest
@testable import Movie_1


class MockAPIManager: APIManagerProtocol {
    
    let movieslistModel: Observable<[Result]?> = Observable(nil)
    let movieDetailsModel: Observable<MovieDetailsModel?> = Observable(nil)
    
    func getFilms(completionHandler: @escaping ([Result]) -> Void) {
        guard let url = Bundle.main.url(forResource: "MoviesList", withExtension: "json") else { return }
        APICaller.shared.performAPICall(url: url, expectingReturnType: MovieResult.self) { movieResult in
            let movies = movieResult.results
            completionHandler(movies)
        }
    }
    
    func getFilmById(id: String, completionHandler: @escaping (MovieDetailsModel) -> Void) {
        guard let url = Bundle.main.url(forResource: "MovieDetails", withExtension: "json") else { return }
        APICaller.shared.performAPICall(url: url, expectingReturnType: MovieDetailsModel.self) { movie in
            completionHandler(movie)
        }
    }
    
    
    
}


