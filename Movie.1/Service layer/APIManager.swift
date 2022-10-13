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
    func getFilms(completionHandler: @escaping ([Result]) -> Void) throws
    func getFilmById(id: String, completionHandler: @escaping (MovieDetailsModel) -> Void) throws
}

//MARK: - APIManager
final class APIManager: APIManagerProtocol {
    
    //MARK: - Private properties
    
    private let apiKey = "be8ef21a1603bea092f25169f28bce3c"
    private let baseURL = "https://api.themoviedb.org/"
    
    //MARK: - Public methods
    
    public func getFilms(completionHandler: @escaping ([Result]) -> Void) throws {
        
        let moviesListURL = baseURL + "3/movie/" + "upcoming" + "?api_key=\(apiKey)"
        guard let url = URL(string: moviesListURL) else {
           throw RequestErrors.invalidURLError
        }
        
        var requestDidFail = false
        AF.request(url).responseDecodable { (response: AFDataResponse<MovieResponse>) in
            switch response.result {
            case .success(let moviesList):
                completionHandler(moviesList.results)
            case .failure(_):
                requestDidFail = true
            }
        }
        
        if requestDidFail {
            throw RequestErrors.URLRequestFailed
        }
    }
    
    public func getFilmById(id: String, completionHandler: @escaping (MovieDetailsModel) -> Void) throws {
        
        let movieDetailURL = baseURL + "3/movie/" + id + "?api_key=\(apiKey)"

        guard let movieDetailURL = URL(string: movieDetailURL)  else {
            throw RequestErrors.invalidURLError
        }
        var requestDidFail = false
        
        AF.request(movieDetailURL).responseDecodable { (response: AFDataResponse<MovieDetailsModel>) in
            switch response.result {
            case .failure(_):
                requestDidFail = true
            case .success(let movie):
                completionHandler(movie)
            }
        }
        
        if requestDidFail {
            throw RequestErrors.URLRequestFailed
        }
    }

}
