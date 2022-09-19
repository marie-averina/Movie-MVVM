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
    
    public func getFilms(page: Int, completionHandler: @escaping ([Result]) -> Void) {
         let urlString = NetworkHelperConstants.moviesListURL + "&page=\(page)"
         guard let url = URL(string: urlString) else { return }
         APICaller.shared.performAPICall(url: url, expectingReturnType: MovieResponse.self) { moviesList in
             var movies = [Result]()
             for i in 0...moviesList.results.count - 1 {
                 var movie = moviesList.results[i]
                 guard let urlString = movie.poster else { return }
                 guard let url = URL(string: urlString) else { return }
                 movie.posterImageData = try? Data(contentsOf: url)
                 movies.append(movie)
             }
             completionHandler(movies)
         }
    
    }
    
    public func getFilmById(id: String, completionHandler: @escaping (MovieDetailsModel) -> Void) {
        
        let finalURL = NetworkHelperConstants.movieDetailURL + id + "?api_key=\(NetworkHelperConstants.apiKey)"
        
        guard let movieDetailURL = URL(string: finalURL)  else { return }
        APICaller.shared.performAPICall(url: movieDetailURL, expectingReturnType: MovieDetailsModel.self) { movie in
            guard let urlString = movie.poster else { return }
            guard let url = URL(string: urlString) else { return }
            var modifiedMovie = movie
            modifiedMovie.posterImageData = try? Data(contentsOf: url)
            completionHandler(modifiedMovie)
        }
    }
}
