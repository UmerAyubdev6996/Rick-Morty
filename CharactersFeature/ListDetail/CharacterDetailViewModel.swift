//
//  CharacterDetailViewModel.swift
//  AssignmentApp
//
//  Created by Umer Ayub on 08/11/2025.
//

import Foundation
import Models
import Combine

public final class CharacterDetailViewModel: ObservableObject {
    @Published public private(set) var character: Character

    public init(character: Character) {
        self.character = character
    }
}
