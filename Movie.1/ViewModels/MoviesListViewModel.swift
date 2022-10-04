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
            try self.apiManager.getFilms() { [weak self] movies in
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
    
    private func getImageData(posterPath: String) -> Data {
        let futureImageData = ImageData(posterPath: posterPath)
        var imageData = Data()
        do {
         try futureImageData.loadImage() { data in
                imageData = data
            }
        } catch let error as RequestErrors {
            onErrorHandling?(error.rawValue)
        } catch {
            onErrorHandling?("Unknown error")
        }
        return imageData
    }
    
    //MARK: - Private methods
    
    private func processFetchedMovies(movies: [Result]) {
        self.movies = movies
        var cellModels = [MovieCellModel]()
        for movie in movies {
            do {
                try cellModels.append(createCellViewModel(movie: movie))
            } catch let error as RequestErrors {
                onErrorHandling?(error.rawValue)
            } catch {
                onErrorHandling?("Unknown error")
            }
        }
        self.cellModels = cellModels
    }
    
    private func createCellViewModel(movie: Result) throws -> MovieCellModel {
     
        let imageData = getImageData(posterPath: movie.posterPath)
        return MovieCellModel(titleText: movie.title,
                                  rateText: String(movie.voteAverage),
                                  yearText: movie.releaseDate,
                                  imageData: imageData)
    }
}


//MARK: - Processing user's chooice

extension MoviesListViewModel {
    func userPressed(at indexPath: IndexPath) {
        let movie = self.movies[indexPath.row]
        self.selectedMovie = movie
    }
}
