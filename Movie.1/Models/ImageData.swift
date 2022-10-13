//
//  ImageData.swift
//  Movie.1
//
//  Created by Мария Аверина on 04.10.2022.
//

import Foundation


struct ImageData {
    
    public let posterPath: String
    
    public func loadImage(completionHandler: @escaping (Data) -> Void) throws {
        
        let urlString = "https://image.tmdb.org/t/p/w500/\(posterPath)"
        guard let url = URL(string: urlString) else {
            throw RequestErrors.invalidURLError
        }
        
        do {
            let imageData = try Data(contentsOf: url)
            completionHandler(imageData)
        } catch {
            throw RequestErrors.imageFailedToLoad
        }
    }
    
}
