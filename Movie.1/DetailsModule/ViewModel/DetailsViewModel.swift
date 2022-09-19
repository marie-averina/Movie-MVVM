//
//  DetailsViewModel.swift
//  Movie.1
//
//  Created by Мария Аверина on 05.09.2022.
//

import Foundation

final class DetailsViewModel {
    
    //MARK: - Public properties
    public let movieDetailModel: Observable<MovieDetailsModel?> = Observable(nil)
    public var isToShowLoader: Observable<Bool> = Observable(false)
    
    //MARK: - Private properties
    private let apiManager: APIManagerProtocol!
    
    //MARK: - Initialization
    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    //MARK: - Public methods
    public func initFetchProcess(id: String, complettion: @escaping (Observable<MovieDetailsModel?>)->()) {
        
        self.isToShowLoader.value = true
        
        self.apiManager.getFilmById(id: id) { [weak self] movie in
            self?.isToShowLoader.value = false
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.movieDetailModel.value = movie
            }
        }
        complettion(self.movieDetailModel)
    }
    
}
