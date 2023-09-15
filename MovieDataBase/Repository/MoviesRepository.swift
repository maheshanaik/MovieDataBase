//
//  MoviesRepository.swift
//  MovieDataBase
//
//  Created by Mahesh Naik on 14/09/23.
//

import Foundation

enum AppError: Error {
    case parsingFailed
    case dataNotFound
}


protocol MoviesRepositoryProtocol {
    func getMovies(_ fileName: String) async throws -> [Movie]
}


class MovieRepository: MoviesRepositoryProtocol {
    func getMovies(_ fileName: String) async throws -> [Movie] {
        do {
            return try await JSONHelper.shared.getDataFromJson(fileName: fileName, type: [Movie].self)
        } catch {
            throw error
        }
    }
}
