//
//  ViewController.swift
//  MovieDataBase
//
//  Created by Mahesh Naik on 14/09/23.
//

import UIKit

enum ViewType {
    case search
    case filter
}

enum Filter: CaseIterable {
    case year
    case genre
    case directors
    case actors
    case allMovies
    
    var title: String {
        switch self {
        case .year:
            return "Year"
        case .genre:
            return "Genre"
        case .directors:
            return "Directors"
        case .actors:
            return "Actors"
        case .allMovies:
            return "All Movies"
        }
    }
}

struct Section {
    var filterType: Filter
    var isExpanded: Bool
    var items: [Listable]
}

class HomeViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButtonWidthConstraint: NSLayoutConstraint!
    var viewModel: MoviesViewModel = MoviesViewModel(repository: MovieRepository())
    
    var searchResults: [Movie] = []
    var viewType: ViewType = .filter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: SectionHeaderView.identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        tableView.register(UINib(nibName: FilterTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FilterTableViewCell.identifier)
        tableView.register(UINib(nibName: MovieTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        navigationItem.title = "Movie Database"
        Task {
            let _ = try await viewModel.getMovies(fileName: "movies")
            tableView.reloadData()
        }

    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        view.endEditing(true)
        searchBar.text = ""
        cancelButtonWidthConstraint.constant = 0.0
        viewType = .filter
        searchResults = []
        tableView.reloadData()
    }
    
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch viewType {
        case .filter:
            return viewModel.dataSource.count
        case .search:
            return 1
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewType {
        case .filter:
            return viewModel.dataSource[section].isExpanded ? viewModel.dataSource[section].items.count : 0
        case .search:
            return searchResults.count
        }
       
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewType {
        case .filter:
            let  filterType = viewModel.dataSource[indexPath.section].filterType
            switch filterType {
            case .allMovies:
                let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
                guard let movie = viewModel.dataSource[indexPath.section].items[indexPath.row] as? Movie else {
                    return UITableViewCell()
                }
                cell.configureUI(movie)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier, for: indexPath) as! FilterTableViewCell
                cell.configureUI(viewModel.dataSource[indexPath.section].items[indexPath.row].title)
                return cell
            }
        case .search:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
            let movie = searchResults[indexPath.row]
            cell.configureUI(movie)
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let  filterType = viewModel.dataSource[indexPath.section].filterType
        switch viewType {
        case .search:
            return 198
        case .filter:
            switch filterType {
            case .allMovies:
                return 198
            default:
                return 45
            }
        }
       
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewType {
        case .search:
            return nil
        case .filter:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as! SectionHeaderView
            headerView.configureUI(viewModel.dataSource[section].filterType.title)

            headerView.updateImage(isExpanded: viewModel.dataSource[section].isExpanded)
            headerView.tag = section
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sectionHeaderTapped(_:)))
            headerView.addGestureRecognizer(tapGestureRecognizer)

            return headerView
        }
        
    }

    @objc func sectionHeaderTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let headerView = gestureRecognizer.view as? SectionHeaderView else {
            return
        }
        let section = headerView.tag
        viewModel.dataSource[section].isExpanded.toggle()
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewType {
        case .filter:
            let filterType = viewModel.dataSource[indexPath.section].filterType
            switch filterType {
            case .allMovies:
                guard let movie = viewModel.dataSource[indexPath.section].items[indexPath.row] as? Movie else {
                    return
                }
                showMovieDetails(movie)
            default:
                let selectedItem = viewModel.dataSource[indexPath.section].items[indexPath.row]
                let movies = viewModel.getFilteredMovies(filter: filterType, selectedItem: selectedItem.title ?? "")
                let vc = MovieListViewController.instansiateFromStoryBoard()
                vc.movies = movies
                navigationController?.pushViewController(vc, animated: true)
            }
        case .search:
            showMovieDetails(searchResults[indexPath.row])
        }
    }
    
    private func showMovieDetails(_ movie: Movie) {
        let vc = MovieDetailsViewController.instansiateFromStoryBoard()
        vc.movie = movie
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewType = .search
        cancelButtonWidthConstraint.constant = 78
        tableView.reloadData()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let key = searchBar.text else {
            return
        }
        searchResults = viewModel.searchMovie(key: key)
        tableView.reloadData()
    }
    
}
