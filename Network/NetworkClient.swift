//
//  NetworkClient.swift
//  AssignmentApp
//
//  Created by Umer Ayub on 07/11/2025.
//

import Foundation
import Models  

// MARK: - Network Errors
public enum NetworkError: Error, LocalizedError {
    case badURL
    case requestFailed
    case invalidResponse
    case decodingFailed

    public var errorDescription: String? {
        switch self {
        case .badURL: return "Invalid URL"
        case .requestFailed: return "Network request failed"
        case .invalidResponse: return "Server returned invalid response"
        case .decodingFailed: return "Failed to decode data"
        }
    }
}

// MARK: - NetworkClient
public final class NetworkClient {
    private let baseURL = "https://rickandmortyapi.com/api"

    public init() {}

    // Generic GET request method
    public func fetch<T: Decodable>(_ endpoint: String, type: T.Type) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.badURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
