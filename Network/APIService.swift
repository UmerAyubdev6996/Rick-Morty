//
//  APIService.swift
//  AssignmentApp
//
//  Created by Umer Ayub on 07/11/2025.
//

import Foundation
import Models

public final class APIService {
    private let client = NetworkClient()

    public init() {}

    public func fetchCharacters(page: Int) async throws -> [CharacterDTO] {
        let endpoint = "/character?page=\(page)"
        let response = try await client.fetch(endpoint, type: CharacterListResponse.self)
        return response.results
    }
}
