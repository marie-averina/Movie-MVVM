//
//  DetailsViewController.swift
//  Movie.1
//
//  Created by Мария Аверина on 14.09.2022.
//

import UIKit
import Alamofire

final class DetailsViewController: UIViewController {
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    //MARK: - Private properties
    
    private var viewModel: DetailsViewModel?
    private var movieId: String?
    
    //MARK: - Initialization
    
    convenience init() {
        self.init(viewModel: nil, movieId: nil)
    }
        
    init(viewModel: DetailsViewModel?, movieId: String?) {
        self.viewModel = viewModel
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: DetailsViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
    }
    
    //MARK: - Private methods
    
    private func initViewModel() {
        guard let movieId = movieId else { return }
        
        viewModel?.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel?.isLoading ?? false
                if isLoading {
                    self?.view.activityStartAnimating(activityColor: .red, backgroundColor: .white.withAlphaComponent(1))
                } else {
                    self?.view.activityStopAnimating()
                }
            }
        }
        
        viewModel?.updateImageLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel?.imageIsLoading ?? false
                if isLoading {
                    self?.posterImageView.activityStartAnimating(activityColor: .white, backgroundColor: .red.withAlphaComponent(0.5))
                } else {
                    self?.posterImageView.activityStopAnimating()
                }
            }
        }
        
        viewModel?.reloadData = { [weak self] viewData in
            self?.setupData(movie: viewData)
        }
        
        viewModel?.reloadImageData = { [weak self] imageData in
            self?.posterImageView.load(data: imageData)
        }
        
        viewModel?.onErrorHandling = { errorText in
            self.showAlert(title: "Error", message: errorText)
        }
        
        viewModel?.initFetchProcess(id: movieId)
        
    }
   
    private func setupData(movie: MovieDetailsModel) {
        guard let rate = movie.voteAverage else {return }
        self.navigationController?.navigationBar.topItem?.title = movie.title
        releaseDateLabel.text = movie.releaseDate
        rateLabel.text = String(rate)
        languageLabel.text = movie.originalLanguage
        overviewLabel.text = movie.overview
        viewModel?.loadImage(posterPath: movie.posterPath)
    }
    
}
