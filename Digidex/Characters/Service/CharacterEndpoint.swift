//
//  CharacterEndpoint.swift
//  RickAndMorty
//

import Foundation

enum CharacterEndpoint {
    case get(page: Int, pageSize: Int)
    case detail(id: Int)

    func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("digimon")
        case .detail(let id):
            return baseURL.appendingPathComponent("digimon/\(id)")
        }
    }
}
