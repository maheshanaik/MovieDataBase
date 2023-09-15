//
//  JSONHelper.swift
//  MovieDataBase
//
//  Created by Mahesh Naik on 14/09/23.
//

import Foundation

class JSONHelper {
    static let shared = JSONHelper()
    private init() {}
    
    func getDataFromJson<T: Decodable>(fileName: String, type: T.Type) async throws -> T {
        if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: fileURL)
                let result = try JSONDecoder().decode(type.self, from: jsonData)
                return result
            } catch {
                throw AppError.parsingFailed
            }
        } else {
            throw AppError.dataNotFound
        }
    }
}
