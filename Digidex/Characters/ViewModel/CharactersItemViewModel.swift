//
//  CharactersItemViewModel.swift
//  RickAndMorty
//

import Foundation

struct CharactersItemViewModel {
    let id: Int
    let name: String
    let image: String

    init(characters: DigimonResult) {
        self.id = characters.id
        self.name = characters.name
        self.image = characters.image
    }
}
