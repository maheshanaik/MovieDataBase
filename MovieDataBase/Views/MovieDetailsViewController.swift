//
//  MovieDetailsViewController.swift
//  MovieDataBase
//
//  Created by Mahesh Naik on 14/09/23.
//

import UIKit

enum RatingSource: Int {
    case imdb = 0
    case rottenTomatoes = 1
    case metacritic = 2
    
    var title: String {
        switch self {
        case .imdb:
            return "Internet Movie Database"
        case .rottenTomatoes:
            return "Rotten Tomatoes"
        case .metacritic:
            return "Metacritic"
        }
    }
}

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var movie: Movie?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        genreLabel.text = movie?.genre
        releaseDateLabel.text = movie?.released
        plotLabel.text = movie?.plot
        castLabel.text = [(movie?.actors ?? ""),(movie?.director ?? ""), (movie?.writer ?? "")].joined(separator: ", ")
        titleLabel.text = movie?.title
        guard let url = URL(string: movie?.poster ?? "") else {
            return
        }
        posterImageView.kf.setImage(with: url)
        setProgress(source: .imdb)
    }
    
    @IBAction func segmentControlAction(_ sender: Any) {
        let ratingSorceType: RatingSource = RatingSource(rawValue: segmentControl.selectedSegmentIndex) ?? .imdb
        setProgress(source: ratingSorceType)
    }
    
    private func setProgress(source: RatingSource) {
        let value = MovieHelper.shared.getRatings(source: source, movie: movie)
        progressView.progress = Float(value)
    }
}
