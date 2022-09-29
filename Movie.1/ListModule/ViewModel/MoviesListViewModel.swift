//
//  MoviesListViewModel.swift
//  Movie.1
//
//  Created by Мария Аверина on 22.09.2022.
//

import Foundation
import Alamofire


final class MoviesListViewModel {
    
    //MARK: - Public properties
    
    public var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    public var numberOfCells: Int {
        return cellModels.count
    }
    
    public var selectedMovie: Result?
    public var reloadTableViewClosure: (()->())?
    public var updateLoadingStatus: (()->())?
    public var onErrorHandling : ((String) -> Void)?
    
    //MARK: - Private properties
    
    private let apiManager: APIManagerProtocol
    private var movies = [Result]()
    private var cellModels = [MovieCellModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    //MARK: - Initialization
    
    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    //MARK: - Public methods
    
    public func fetchMovieList() {
      
        isLoading = true
        
        do {
            try self.apiManager.getFilms(page: 1) { [weak self] movies in
                self?.isLoading = false
                self?.processFetchedMovies(movies: movies)
            }
        } catch RequestErrors.invalidURLError {
            onErrorHandling?("Invalid url")
        } catch RequestErrors.URLRequestFailed {
            onErrorHandling?("Url request failed")
        } catch {
            onErrorHandling?("Unnknowned error")
        }
    }
    
    public func getCellViewModel(at indexPath: IndexPath) -> MovieCellModel {
        return cellModels[indexPath.row]
    }
    
    //MARK: - Private methods
    
    private func processFetchedMovies(movies: [Result]) {
        self.movies = movies
        var cellModels = [MovieCellModel]()
        for movie in movies {
            do {
                try cellModels.append(createCellViewModel(movie: movie))
            } catch RequestErrors.URLRequestFailed {
                onErrorHandling?("URL request failed")
            } catch {
                onErrorHandling?("Unknown error")
            }
        }
        self.cellModels = cellModels
    }
    
    private func createCellViewModel(movie: Result) throws -> MovieCellModel {
     
        guard let data = movie.posterImageData else {
            throw RequestErrors.URLRequestFailed
        }
        return MovieCellModel(titleText: movie.title,
                                  rateText: String(movie.voteAverage),
                                  yearText: movie.releaseDate,
                                  imageData: data)
    }
}


//MARK: - Processing user's chooice

extension MoviesListViewModel {
    func userPressed(at indexPath: IndexPath) {
        let movie = self.movies[indexPath.row]
        self.selectedMovie = movie
    }
}
