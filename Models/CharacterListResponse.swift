//
//  CharacterListResponse.swift
//  AssignmentApp
//
//  Created by Umer Ayub on 07/11/2025.
//

import Foundation

public struct CharacterListResponse: Codable {
    public let info: Info
    public let results: [CharacterDTO]
}

public struct Info: Codable {
    public let count: Int
    public let pages: Int
    public let next: String?
    public let prev: String?
}
