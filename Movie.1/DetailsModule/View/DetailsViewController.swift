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
    
    //MARK: - Public properties
    
    public let movieId: String
    
    //MARK: - Private properties
    
    private let viewModel: DetailsViewModel
    
    //MARK: - Initialization
    
    init?(coder: NSCoder, viewModel: DetailsViewModel, id: String) {
        self.viewModel = viewModel
        self.movieId = id
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder:image:)` to initialize an `ImageViewController` instance.")
    }
    
    // MARK: DetailsViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
    }
    
    //MARK: - Private methods
    
    private func initViewModel() {
        viewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.view.activityStartAnimating(activityColor: .red, backgroundColor: .white.withAlphaComponent(1))
                } else {
                    self?.view.activityStopAnimating()
                }
            }
        }
        
        viewModel.reloadData = { [weak self] viewData in
            self?.setupData(movie: viewData)
        }
        
        viewModel.onErrorHandling = { errorText in
            self.showAlert(title: "Error", message: errorText)
        }
        
        viewModel.initFetchProcess(id: movieId)
    }
   
    private func setupData(movie: MovieDetailsModel) {
        guard let rate = movie.voteAverage,
              let imageData = movie.posterImageData else {
            self.showAlert(title: "Error", message: "Movie details failed to load")
            return
        }
        self.navigationController?.navigationBar.topItem?.title = movie.title
        releaseDateLabel.text = movie.releaseDate
        rateLabel.text = String(rate)
        languageLabel.text = movie.originalLanguage
        overviewLabel.text = movie.overview
        posterImageView.load(data: imageData)
    }
    
   
}
