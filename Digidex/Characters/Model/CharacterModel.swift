//
//  CharacterModel.swift
//  RickAndMorty
//

import Foundation

struct DigimonResult: Equatable {
    let id: Int
    let name: String
    let image: String

    let types: [String]
    let attributes: [String]
    let levels: [String]
    let fields: [String]

    static func == (lhs: DigimonResult, rhs: DigimonResult) -> Bool {
        lhs.id == rhs.id
    }
}

struct DigimonDetailResult: Equatable {
    let id: Int
    let name: String
    let image: String
    let types: [String]
    let attributes: [String]
    let levels: [String]
    let fields: [String]
}
