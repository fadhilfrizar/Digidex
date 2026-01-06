//
//  CharacterService.swift
//  RickAndMorty
//

import Foundation

protocol CharacterService {
    typealias Result = Swift.Result<[DigimonResult], Error>
    typealias DetailResult = Swift.Result<DigimonDetailResult, Error>

    func load(parameters: [String: Any]?, completion: @escaping (Result) -> Void)
    func loadDetail(id: Int, completion: @escaping (DetailResult) -> Void)
}

class CharacterServiceAPI: CharacterService {

    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
        case noInternet
    }

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load(parameters: [String: Any]?, completion: @escaping (CharacterService.Result) -> Void) {
        guard Reachability.shared.isConnected else {
            completion(.failure(Error.noInternet))
            return
        }

        client.get(from: url, parameters: parameters) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(CharacterMapper.mapList(data: data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }

    func loadDetail(id: Int, completion: @escaping (CharacterService.DetailResult) -> Void) {
        guard Reachability.shared.isConnected else {
            completion(.failure(Error.noInternet))
            return
        }

        let detailURL = url.deletingLastPathComponent().appendingPathComponent("digimon/\(id)")

        client.get(from: detailURL, parameters: nil) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(CharacterMapper.mapDetail(data: data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
