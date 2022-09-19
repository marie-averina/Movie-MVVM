//
//  ListViewModel.swift
//  Movie.1
//
//  Created by Мария Аверина on 02.09.2022.
//

import Foundation

final class ListViewModel {
    
    //MARK: - Public properties
    public let movieListModel: Observable<[Result]?> = Observable(nil)
    public var isToShowLoader: Observable<Bool> = Observable(false)
    
    //MARK: - Private properties
    private let apiManager: APIManagerProtocol!
    private var page = 1
    
    //MARK: - Initialization
    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    //MARK: - Public methods
    public func fetchMovieList(complettion: @escaping (Observable<[Result]?>)->()) {
        
        isToShowLoader.value = true
        
        self.apiManager.getFilms(page: page) { [weak self] movies in
            self?.isToShowLoader.value = false
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.movieListModel.value = movies
            }
        }
        complettion(self.movieListModel)
    }
 
}


//MARK: -(Re)Load new page
extension ListViewModel {
    
    public func resetMoviePage() {
        page = 1
    }
    
    public func nextMoviePage() {
         page += 1
        self.apiManager.getFilms(page: page) { [weak self] movies in
            self?.isToShowLoader.value = false
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.movieListModel.value = movies
            }
        }
    }
    
    public func removeAllMovies() {
        self.movieListModel.value = [Result]()
    }
}
