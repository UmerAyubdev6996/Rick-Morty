//
//  CharacterListViewModel.swift
//  AssignmentApp
//
//  Created by Umer Ayub on 07/11/2025.
//

import Foundation
import Combine
import DataLayer
import Models
import Network

@MainActor
public final class CharacterListViewModel: ObservableObject {
    @Published public private(set) var characters: [Character] = []
    @Published public private(set) var isLoading = false
    @Published public private(set) var errorMessage: String?

    private let repository: CharacterRepositoryProtocol
    private var currentPage = 1
    private var isFetching = false
    private let itemsPerPage = 20
    private let maxCharacters = 100

    public init(repository: CharacterRepositoryProtocol = CharacterRepository()) {
        self.repository = repository
    }

    // MARK: - Initial load
    public func loadCharacters() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
            let newCharacters = try await repository.getCharacters(page: currentPage)
            characters = newCharacters
        } catch {
            errorMessage = "Offline mode: showing cached data"

            var cachedAll: [Character] = []
            for page in 1...currentPage {
                if let cached = repository.loadCachedCharacters(page: page) {
                    cachedAll.append(contentsOf: cached)
                }
            }

            if cachedAll.isEmpty {
                errorMessage = "No offline data available."
            }

            characters = cachedAll
        }

        isLoading = false
    }

    // MARK: - Load next page
    public func loadNextPageIfNeeded(currentItem: Character?) async {
        guard let currentItem else { return }
        guard !isFetching else { return }
        guard characters.count < maxCharacters else { return }

        if let index = characters.firstIndex(where: { $0.id == currentItem.id }),
           index >= characters.count - 3 {
            isFetching = true
            defer { isFetching = false }

            currentPage += 1
            do {
                let newCharacters = try await repository.getCharacters(page: currentPage)
                guard !newCharacters.isEmpty else { return }
                characters.append(contentsOf: newCharacters)
            } catch {
                print("Offline: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Refresh (force reload)
    public func refresh() async {
        currentPage = 1
        characters.removeAll()
        errorMessage = nil
        await loadCharacters()

        if characters.isEmpty {
            var cachedAll: [Character] = []
            for page in 1...5 {
                if let cached = repository.loadCachedCharacters(page: page) {
                    cachedAll.append(contentsOf: cached)
                }
            }
            characters = cachedAll
        }
    }
}

