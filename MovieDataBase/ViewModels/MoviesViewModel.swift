//
//  MoviesViewModel.swift
//  MovieDataBase
//
//  Created by Mahesh Naik on 14/09/23.
//

import Foundation

class MoviesViewModel {
    var repository: MoviesRepositoryProtocol
    var movies: [Movie] = []
    var dataSource: [Section] = []
    init(repository: MoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    func getMovies(fileName: String) async throws -> [Movie] {
        do {
            self.movies = try await repository.getMovies(fileName)
            getDataSource()
            return movies
        } catch {
            throw error
        }
    }
    
    private func getDataSource() {
        for filter in Filter.allCases {
            dataSource.append(Section(filterType: filter, isExpanded: false, items: getFilterData(filter)))
        }
    }
    
    func searchMovie(key: String) -> [Movie] {
        return movies.filter({
            return $0.title?.contains(key) ?? false || $0.genre?.contains(key) ?? false || $0.actors?.contains(key) ?? false || $0.director?.contains(key) ?? false
        })
    }
    
    
    private func getFilterData(_ filter: Filter) -> [Listable] {
            switch filter {
            case .year:
                return movies.map { $0.year ?? "" }.removingDuplicates()
            case .genre:
                return movies.map { $0.genre ?? "" }.removingDuplicates()
            case .directors:
                return movies.map { $0.director ?? "" }.removingDuplicates()
            case .actors:
                return movies.map { $0.actors ?? "" }.removingDuplicates()
            case .allMovies:
                return movies
            }
    }
    
    func getFilteredMovies(filter: Filter, selectedItem: String) -> [Movie] {
        switch filter {
        case .year:
            return movies.filter({$0.year?.contains(selectedItem) ?? false})
        case .genre:
            return movies.filter({$0.genre?.contains(selectedItem) ?? false})
        case .directors:
            return movies.filter({$0.director?.contains(selectedItem) ?? false})
        case .actors:
            return movies.filter({$0.actors?.contains(selectedItem) ?? false})
        case .allMovies:
            return movies
        }
    }
}




