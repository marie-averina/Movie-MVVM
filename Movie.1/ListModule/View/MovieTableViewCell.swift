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
    
    //MARK: - Public properties
    
    public var movieCellViewModel : MovieCellViewModel? {
        didSet {
            guard let posterData = movieCellViewModel?.imageData else { return }
            nameLabel.text = movieCellViewModel?.titleText
            rateLabel.text = movieCellViewModel?.rateText
            yearLabel.text = movieCellViewModel?.yearText
            movieImageView.load(data: posterData)
        }
    }
    
}


