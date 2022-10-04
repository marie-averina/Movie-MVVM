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
    public var reloadImageData: ((Data)->())?
    public var updateLoadingStatus: (()->())?
    public var updateImageLoadingStatus: (()->())?
    public var onErrorHandling : ((String) -> Void)?
    public var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    public var imageIsLoading: Bool = false {
        didSet {
            self.updateImageLoadingStatus?()
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
            
        } catch let error as RequestErrors {
            onErrorHandling?(error.rawValue)
        } catch {
            onErrorHandling?("Unknown error")
        }
    }
    
    public func loadImage(posterPath: String) {
        
        let futureImageData = ImageData(posterPath: posterPath)
        imageIsLoading = true
        
        do {
            try futureImageData.loadImage { [weak self] imageData in
                self?.imageIsLoading = false
                DispatchQueue.main.async {
                    self?.reloadImageData?(imageData)
                }
            }
        } catch let error as RequestErrors {
            onErrorHandling?(error.rawValue)
        } catch {
            onErrorHandling?("Unknown error")
        }
    }

}


