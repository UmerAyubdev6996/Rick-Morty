//
//  CharacterRepository.swift
//  AssignmentApp
//
//  Created by Umer Ayub on 07/11/2025.
//

import Foundation
import Models
import Network

public protocol CharacterRepositoryProtocol {
    func getCharacters(page: Int) async throws -> [Character]
    func loadCachedCharacters(page: Int) -> [Character]?
}

public final class CharacterRepository: CharacterRepositoryProtocol {
    private let apiService: APIService
    private let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    private let itemsPerPage = 20
    private let maxCharacters = 100

    public init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }

    public func getCharacters(page: Int) async throws -> [Character] {

        guard (page - 1) * itemsPerPage < maxCharacters else { return [] }

        do {
            let dtos = try await apiService.fetchCharacters(page: page)
            let characters = dtos.compactMap { $0.toDomain() }


            try saveCache(for: page, characters: characters)
            return characters
        } catch {
            if let cached = loadCachedCharacters(page: page) {
                return cached
            } else {
                throw error
            }
        }
    }

    // MARK: - Cache helpers
    private func cacheFile(for page: Int) -> URL {
        cacheDir.appendingPathComponent("characters_page_\(page).json")
    }

    private func saveCache(for page: Int, characters: [Character]) throws {
        let data = try JSONEncoder().encode(characters)
        try data.write(to: cacheFile(for: page), options: .atomic)
    }

    public func loadCachedCharacters(page: Int) -> [Character]? {
        guard let data = try? Data(contentsOf: cacheFile(for: page)) else { return nil }
        return try? JSONDecoder().decode([Character].self, from: data)
    }
}
