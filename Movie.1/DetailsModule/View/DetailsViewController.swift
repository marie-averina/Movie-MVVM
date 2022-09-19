//
//  DetailsViewController.swift
//  Movie.1
//
//  Created by Мария Аверина on 14.09.2022.
//

import UIKit
import Alamofire

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    //MARK: - Public properties
    public var movieId: String?
    
    //MARK: - Private properties
    private var viewModel: DetailsViewModel!
    
    // MARK: AboutMovieViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = DetailsViewModel()
        callAPI()
    }
    
    //MARK: - Private methods
    private func callAPI() {
        guard let id = movieId else { return }
        
        self.view.activityStartAnimating(activityColor: .red, backgroundColor: .black.withAlphaComponent(0.5))
        viewModel.initFetchProcess(id: id) { movie in }
        
        viewModel.movieDetailModel.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.setUpData()
            }
        }
        
        viewModel.isToShowLoader.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.view.activityStopAnimating()
            }
        }
    }

    private func setUpData() {
        guard let movie = viewModel.movieDetailModel.value,
        let posterData = movie.posterImageData,
        let voteAverage = movie.voteAverage else { return }
        self.navigationController?.navigationBar.topItem?.title = movie.title
        releaseDateLabel.text = movie.releaseDate
        rateLabel.text = String(voteAverage)
        languageLabel.text = movie.originalLanguage
        overviewLabel.text = movie.overview
        posterImageView.load(data: posterData)
    }
}
