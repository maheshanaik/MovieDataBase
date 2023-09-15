//
//  MovieListViewController.swift
//  MovieDataBase
//
//  Created by Mahesh Naik on 14/09/23.
//

import UIKit

class MovieListViewController: UIViewController {

    var movies = [Movie]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: MovieTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configureUI(movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 198
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let vc = MovieDetailsViewController.instansiateFromStoryBoard()
        vc.movie = movie
        navigationController?.pushViewController(vc, animated: true)
    }
}



