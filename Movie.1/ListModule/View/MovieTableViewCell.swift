//
//  MovieTableViewCell.swift
//  Movie.1
//
//  Created by Мария Аверина on 17.12.2021.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
 
    //MARK: - @IBOutlet
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    //MARK: - Public methods
     public func useData(data: Result) {
        guard let posterData = data.posterImageData else { return }
        nameLabel.text = data.title
        rateLabel.text = String(data.voteAverage)
        yearLabel.text = data.releaseDate
        movieImageView.load(data: posterData)
    }
}


