//
//  DetailsViewModel.swift
//  Movie.1
//
//  Created by Мария Аверина on 05.09.2022.
//

import Foundation
import Alamofire
final class DetailsViewModel {
    
    //MARK: - Public properties
    
    public var reloadData: ((MovieDetailsModel)->())?
    public var updateLoadingStatus: (()->())?
    public var onErrorHandling : ((String) -> Void)?
    public var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    //MARK: - Private properties
    
    private let apiManager: APIManagerProtocol!
    
    //MARK: - Initialization
    
    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }
    
    //MARK: - Public methods
    
    public func initFetchProcess(id: String) {
        
        isLoading = true
        
        do {
            try self.apiManager.getFilmById(id: id) { [weak self] movie in
                self?.isLoading = false
                DispatchQueue.main.async {
                    self?.reloadData?(movie)
                }
            }
            
        } catch RequestErrors.invalidURLError {
            onErrorHandling?("Invalid url")
        } catch RequestErrors.URLRequestFailed {
            onErrorHandling?("Url request failed")
        } catch {
            onErrorHandling?("Unnknowned error")
        }
    }
}


