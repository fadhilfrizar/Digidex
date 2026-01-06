//
//  CharacterMapper.swift
//  RickAndMorty
//

import Foundation

enum CharacterMapper {

    // MARK: - DTOs (robust)
    struct ListRootDTO: Decodable {
        let items: [DigimonItemDTO]

        enum CodingKeys: String, CodingKey {
            case content
            case data
            case results
        }

        init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: CodingKeys.self)

            if let content = try? c.decode([DigimonItemDTO].self, forKey: .content) {
                items = content
                return
            }
            if let data = try? c.decode([DigimonItemDTO].self, forKey: .data) {
                items = data
                return
            }
            if let results = try? c.decode([DigimonItemDTO].self, forKey: .results) {
                items = results
                return
            }
            items = []
        }
    }

    struct DigimonItemDTO: Decodable {
        let id: Int?
        let name: String?
        let image: String?
    }

    struct DetailDTO: Decodable {
        struct NamedDTO: Decodable { let name: String? }
        struct ImageDTO: Decodable {
            let href: String?
            let url: String?
            var best: String { href ?? url ?? "" }
        }

        let id: Int?
        let name: String?
        let images: [ImageDTO]?
        let types: [NamedDTO]?
        let attributes: [NamedDTO]?
        let levels: [NamedDTO]?
        let fields: [NamedDTO]?
    }

    // MARK: - Map
    static func mapList(data: Data, response: HTTPURLResponse) -> CharacterService.Result {
        guard (200...299).contains(response.statusCode) else {
            return .failure(CharacterServiceAPI.Error.invalidData)
        }
        do {
            let root = try JSONDecoder().decode(ListRootDTO.self, from: data)
            let digimons = root.items.compactMap { dto -> DigimonResult? in
                guard let id = dto.id, let name = dto.name else { return nil }
                return DigimonResult(
                    id: id,
                    name: name,
                    image: dto.image ?? "",
                    types: [],
                    attributes: [],
                    levels: [],
                    fields: []
                )
            }
            return .success(digimons)
        } catch {
            return .failure(CharacterServiceAPI.Error.invalidData)
        }
    }

    static func mapDetail(data: Data, response: HTTPURLResponse) -> CharacterService.DetailResult {
        guard (200...299).contains(response.statusCode) else {
            return .failure(CharacterServiceAPI.Error.invalidData)
        }
        do {
            let dto = try JSONDecoder().decode(DetailDTO.self, from: data)
            let id = dto.id ?? -1
            let name = dto.name ?? "-"

            let detail = DigimonDetailResult(
                id: id,
                name: name,
                image: dto.images?.first?.best ?? "",
                types: (dto.types ?? []).compactMap { $0.name },
                attributes: (dto.attributes ?? []).compactMap { $0.name },
                levels: (dto.levels ?? []).compactMap { $0.name },
                fields: (dto.fields ?? []).compactMap { $0.name }
            )
            return .success(detail)
        } catch {
            return .failure(CharacterServiceAPI.Error.invalidData)
        }
    }
}
