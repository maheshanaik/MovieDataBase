//
//  MovieHelper.swift
//  MovieDataBase
//
//  Created by Mahesh Naik on 14/09/23.
//

import Foundation
class MovieHelper {
    static let shared = MovieHelper()
    private init() {}
    
    func getRatings(source: RatingSource, movie: Movie?) -> Double {
        guard let movie = movie else {return 0.0}
        let rating = movie.ratings?.first(where: {$0.source?.title == source.title})?.value ?? ""
        switch source {
        case .imdb:
            let components = rating.split(separator: "/")
            if components.count >= 2 {
                let extractedString = String(components[0])
                let result = (Double(extractedString) ?? 0.0) / 10
                return result
            }
        case .rottenTomatoes:
            let components = rating.split(separator: "%")
            if components.count >= 1 {
                let extractedString = String(components[0])
                let result = ((Double(extractedString) ?? 0.0) / 100)
                return result
            }
        case .metacritic:
            let components = rating.split(separator: "/")
            if components.count >= 2 {
                let extractedString = String(components[0])
                let result = ((Double(extractedString) ?? 0.0) / 100)
                return result
            }
        }
        return 0.0
    }
}
