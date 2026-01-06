//
//  CharactersViewModel.swift
//  RickAndMorty
//

import Foundation

class CharactersViewModel {
    private let service: CharacterService

    init(service: CharacterService){
        self.service = service
    }

    typealias Observer<T> = (T) -> Void

    var onCharactersLoad: Observer<[DigimonResult]>?
    var onCharactersError: Observer<Error>?
    var onCharactersLoading: Observer<Bool>?

    var parameters: [String: Any] = [:]

    // ✅ requirement: 8 cards per page
    func fetchCharacters(
        pages: Int = 0,
        query: String = "",
        type: String = "",
        attribute: String = "",
        level: String = "",
        field: String = ""
    ){
        onCharactersLoading?(true)

        parameters.removeAll()
        parameters["page"] = pages
        parameters["pageSize"] = 8

        // server-side filters (from docs)
        if !query.isEmpty { parameters["name"] = query }
        if !attribute.isEmpty { parameters["attribute"] = attribute }
        if !level.isEmpty { parameters["level"] = level }

        // type/field may not be supported as query params on list in all cases.
        // We'll keep them for future extension (and client-side filtering in controller).
        if !type.isEmpty { parameters["type"] = type }
        if !field.isEmpty { parameters["field"] = field }

        service.load(parameters: parameters) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(items):
                self.onCharactersLoad?(items)
            case let .failure(error):
                self.onCharactersError?(error)
            }
            self.onCharactersLoading?(false)
        }
    }

    func fetchDetail(id: Int, completion: @escaping (Result<DigimonDetailResult, Error>) -> Void) {
        service.loadDetail(id: id, completion: completion)
    }
}
