//
//  APIManager.swift
//  Movie.1
//
//  Created by Мария Аверина on 16.06.2022.
//

import Foundation
import Alamofire

//MARK: - APIManagerProtocol
protocol APIManagerProtocol {
    func getFilms(page: Int, completionHandler: @escaping ([Result]) -> Void)
    func getFilmById(id: String, completionHandler: @escaping (MovieDetailsModel) -> Void)
}

//MARK: - APIManager
final class APIManager: APIManagerProtocol {
    
    //MARK: - Private properties
    
    private let apiKey = "be8ef21a1603bea092f25169f28bce3c"
    private let baseURL = "https://api.themoviedb.org/"
    
    //MARK: - Public methods
    
    public func getFilms(page: Int, completionHandler: @escaping ([Result]) -> Void) {
        
        let moviesListURL = baseURL + "3/movie/" + "upcoming" + "?api_key=\(apiKey)"
        let urlString = moviesListURL + "&page=\(page)"
        guard let url = URL(string: urlString) else { return }
        
        APICaller.shared.performAPICall(url: url, expectingReturnType: MovieResponse.self) { [weak self] moviesList in
            var movies = [Result]()
            for i in 0...moviesList.results.count - 1 {
                var movie = moviesList.results[i]
                guard let url = self?.getURL(posterPath: movie.posterPath) else { return }
                movie.posterImageData = try? Data(contentsOf: url)
                movies.append(movie)
            }
            completionHandler(movies)
        }
    }
    
    public func getFilmById(id: String, completionHandler: @escaping (MovieDetailsModel) -> Void) {
        
        let movieDetailURL = baseURL + "3/movie/"
        let finalURL = movieDetailURL + id + "?api_key=\(apiKey)"
        guard let movieDetailURL = URL(string: finalURL)  else { return }
        
        APICaller.shared.performAPICall(url: movieDetailURL, expectingReturnType: MovieDetailsModel.self) { [weak self] movie in
            var modifiedMovie = movie
            guard let url = self?.getURL(posterPath: movie.posterPath) else { return }
            modifiedMovie.posterImageData = try? Data(contentsOf: url)
            completionHandler(modifiedMovie)
        }
    }
    
    //MARK: - Private methods
    
    private func getURL(posterPath: String) -> URL {
        let urlString = "https://image.tmdb.org/t/p/w500/\(posterPath)"
        guard let url = URL(string: urlString) else { fatalError() }
        return url
    }
}
