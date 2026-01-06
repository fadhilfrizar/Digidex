//
//  Helper.swift
//  RickAndMorty
//

import Foundation
import Network

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T

    init(decoratee: T) {
        self.decoratee = decoratee
    }

    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        completion()
    }
}

extension MainQueueDispatchDecorator: CharacterService where T == CharacterService {
    func load(parameters: [String : Any]?, completion: @escaping (CharacterService.Result) -> Void) {
        decoratee.load(parameters: parameters) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }

    func loadDetail(id: Int, completion: @escaping (CharacterService.DetailResult) -> Void) {
        decoratee.loadDetail(id: id) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

// Simple reachability singleton
final class Reachability {
    static let shared = Reachability()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "reachability.queue")

    private(set) var isConnected: Bool = true

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
}
