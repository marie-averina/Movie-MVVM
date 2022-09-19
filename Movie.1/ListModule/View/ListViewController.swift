//
//  ListViewController.swift
//  Movie.1
//
//  Created by Мария Аверина on 17.12.2021.
//

import UIKit

final class ListViewController: UIViewController {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var movieTableView: UITableView!
   
    //MARK: - Private properties
    private var viewModel: ListViewModel!
    
    // MARK: ListViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ListViewModel()
        movieTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callAPI()
    }
    
    //MARK: - Private methods
    private func callAPI() {
        //indicate the process of fetching data
        self.view.activityStartAnimating(activityColor: .red, backgroundColor: .black.withAlphaComponent(0.5))
        
        //indicate the process of reloaing and fetching new data
        movieTableView.setUpRefreshControl(selector: #selector(didPullToRefresh(_:)))
        
        //process of fetching data
        viewModel.fetchMovieList { movies in }
        viewModel.movieListModel.bind { [weak self] newsModel in
            DispatchQueue.main.async {
                self?.movieTableView.reloadData()
            }
        }
        viewModel.isToShowLoader.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.view.activityStopAnimating()
            }
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = viewModel.movieListModel.value?.count else { return 0 }
        return number
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell,
              let movies = viewModel.movieListModel.value
        else { return UITableViewCell() }
        let movie = movies[indexPath.row]
        let lastElement = movies.count - 1
        cell.useData(data: movie)
        if indexPath.row == lastElement { viewModel.nextMoviePage() }
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movies = viewModel.movieListModel.value else { return }
        let movie = movies[indexPath.row]
        let movieId = String(movie.id)
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
            vc.movieId = movieId
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
}


//MARK: - Reload data
extension ListViewController {
    @objc func didPullToRefresh(_ sender : UIRefreshControl) {
        view.activityStartAnimating(activityColor: .red, backgroundColor: .gray)
        viewModel.removeAllMovies()
        movieTableView.reloadData()
        viewModel.resetMoviePage()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.viewModel.fetchMovieList(complettion: { _ in })
        }
    }

}
