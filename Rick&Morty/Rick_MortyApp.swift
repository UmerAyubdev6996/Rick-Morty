//
//  Rick_MortyApp.swift
//  Rick&Morty
//
//  Created by Umer Ayub on 10/11/2025.
//

import SwiftUI
import CharactersFeature
import SDWebImage

@main
struct Rick_MortyApp: App {

    @StateObject private var viewModel = CharacterListViewModel()
    var body: some Scene {
        WindowGroup {
            CharacterListView(viewModel: viewModel)
        }
    }
}
