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
    func getFilms(page: Int, completionHandler: @escaping ([Result]) -> Void) throws
    func getFilmById(id: String, completionHandler: @escaping (MovieDetailsModel) -> Void) throws
}

//MARK: - APIManager
final class APIManager: APIManagerProtocol {
    
    //MARK: - Private properties
    
    private let apiKey = "be8ef21a1603bea092f25169f28bce3c"
    private let baseURL = "https://api.themoviedb.org/"
    
    //MARK: - Public methods
    
    public func getFilms(page: Int, completionHandler: @escaping ([Result]) -> Void) throws {
        
        let moviesListURL = baseURL + "3/movie/" + "upcoming" + "?api_key=\(apiKey)"
        let urlString = moviesListURL + "&page=\(page)"
        guard let url = URL(string: urlString) else {
           throw RequestErrors.invalidURLError
        }
        
        var requestDidFail = false
        AF.request(url).responseDecodable { [weak self] (response: AFDataResponse<MovieResponse>) in
            switch response.result {
            case .success(let moviesList):
                var movies = [Result]()
                for i in 0...moviesList.results.count - 1 {
                    var movie = moviesList.results[i]
                    guard let url = self?.getURL(posterPath: movie.posterPath) else { return }
                    movie.posterImageData = try? Data(contentsOf: url)
                    movies.append(movie)
                }
                completionHandler(movies)
            case .failure(_):
                requestDidFail = true
            }
        }
        
        if requestDidFail {
            throw RequestErrors.URLRequestFailed
        }
    }
    
    public func getFilmById(id: String, completionHandler: @escaping (MovieDetailsModel) -> Void) throws {
        
        let movieDetailURL = baseURL + "3/movie/"
        let finalURL = movieDetailURL + id + "?api_key=\(apiKey)"
        guard let movieDetailURL = URL(string: finalURL)  else {
            throw RequestErrors.invalidURLError
        }
        var requestDidFail = false
        
        AF.request(movieDetailURL).responseDecodable { [weak self] (response: AFDataResponse<MovieDetailsModel>) in
            switch response.result {
            case .failure(_):
                requestDidFail = true
            case .success(let movie):
                var modifiedMovie = movie
                guard let url = self?.getURL(posterPath: movie.posterPath) else { return }
                modifiedMovie.posterImageData = try? Data(contentsOf: url)
                completionHandler(modifiedMovie)
            }
        }
        
        if requestDidFail {
            throw RequestErrors.URLRequestFailed
        }
    }
    
    //MARK: - Private methods
    
    private func getURL(posterPath: String) -> URL? {
        let urlString = "https://image.tmdb.org/t/p/w500/\(posterPath)"
        let url = URL(string: urlString)
        return url
    }
}
