//
//  Character.swift
//  AssignmentApp
//
//  Created by Umer Ayub on 06/11/2025.
//

import Foundation

// MARK: - Network DTO
public struct CharacterDTO: Codable {
    public let id: Int
    public let name: String
    public let status: String
    public let species: String
    public let gender: String
    public let origin: OriginDTO
    public let location: LocationDTO
    public let image: String
}


public struct OriginDTO: Codable {
    public let name: String
}

public struct LocationDTO: Codable {
    public let name: String
}

// MARK: - Domain Model
public struct Character: Codable, Identifiable, Equatable {
    
    public let id: Int
    public let name: String
    public let status: String
    public let species: String
    public let gender: String
    public let originName: String
    public let locationName: String
    public let imageURL: URL
}

// MARK: - Mapping
public extension CharacterDTO {
    func toDomain() -> Character {
        Character(
            id: id,
            name: name,
            status: status,
            species: species,
            gender: gender,
            originName: origin.name,
            locationName: location.name,
            imageURL: URL(string: image) ?? URL(string: "https://via.placeholder.com/150")!
        )
    }
}

