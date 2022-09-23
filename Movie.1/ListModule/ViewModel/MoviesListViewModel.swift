//
//  MoviesListViewModel.swift
//  Movie.1
//
//  Created by Мария Аверина on 22.09.2022.
//

import Foundation


final class MoviesListViewModel {
    
    //MARK: - Public properties
    
    public var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    public var numberOfCells: Int {
        return cellViewModels.count
    }
    
    public var selectedMovie: Result?
    public var reloadTableViewClosure: (()->())?
    public var updateLoadingStatus: (()->())?
    
    //MARK: - Private properties
    
    private let apiManager: APIManagerProtocol!
    private var movies = [Result]()
    private var cellViewModels = [MovieCellViewModel]() {
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
        
        self.apiManager.getFilms(page: 1) { [weak self] movies in
            self?.isLoading = false
            self?.processFetchedMovies(movies: movies)
        }
    }
    
    public func getCellViewModel(at indexPath: IndexPath) -> MovieCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    //MARK: - Private methods
    
    private func processFetchedMovies(movies: [Result]) {
        self.movies = movies
        var cellViewModels = [MovieCellViewModel]()
        for movie in movies {
            cellViewModels.append(createCellViewModel(movie: movie))
        }
        self.cellViewModels = cellViewModels
    }
    
    private func createCellViewModel(movie: Result) -> MovieCellViewModel {
     
        guard let data = movie.posterImageData else { fatalError() }
        return MovieCellViewModel(titleText: movie.title,
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
