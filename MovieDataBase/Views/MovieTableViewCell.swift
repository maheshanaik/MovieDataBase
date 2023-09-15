//
//  MovieTableViewCell.swift
//  MovieDataBase
//
//  Created by Mahesh Naik on 14/09/23.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
    
    static let identifier = "MovieTableViewCell"

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moviePosterImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureUI(_ movie: Movie) {
        yearLabel.text = movie.year
        languageLabel.text = movie.language
        titleLabel.text = movie.title
        guard let url = URL(string: movie.poster ?? "") else {
            return
        }
        moviePosterImage.kf.setImage(with: url)
    }
    
}
