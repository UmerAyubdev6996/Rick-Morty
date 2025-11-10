//
//  CharacterListView.swift
//  AssignmentApp
//
//  Created by Umer Ayub on 07/11/2025.
//

import SwiftUI
import Models
import SharedUI

public struct CharacterListView: View {
    @ObservedObject var viewModel: CharacterListViewModel
    @State private var searchText = ""
    @Namespace private var animation

    public init(viewModel: CharacterListViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                Group {
                    if viewModel.isLoading {
                        ShimmerLoadingView()
                            .transition(.opacity.combined(with: .scale))
                    } else if let error = viewModel.errorMessage {
                        errorView(error)
                            .transition(.opacity)
                    } else {
                        characterList
                            .transition(.opacity.combined(with: .scale))
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.isLoading)
                .animation(.easeInOut(duration: 0.3), value: viewModel.errorMessage)
            }
            .navigationTitle("Rick & Morty")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task { await viewModel.refresh() }
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {}
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .rotationEffect(.degrees(viewModel.isLoading ? 360 : 0))
                            .animation(viewModel.isLoading ?
                                       .linear(duration: 1).repeatForever(autoreverses: false) :
                                       .default,
                                       value: viewModel.isLoading)
                    }
                }
            }
            .searchable(text: $searchText)
            .task { await viewModel.loadCharacters() }
        }
    }

    // MARK: - List of characters
    private var characterList: some View {
        List(filteredCharacters, id: \.id) { character in
            NavigationLink {
                CharacterDetailView(viewModel: CharacterDetailViewModel(character: character))
            } label: {
                CharacterRow(character: character)
                    .scaleEffect(1.0)
                    .opacity(1.0)
                    .animation(.easeInOut(duration: 0.25), value: character.id)
            }
            .onAppear {
                Task { await viewModel.loadNextPageIfNeeded(currentItem: character) }
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .refreshable {
            Task { await viewModel.refresh() }
            withAnimation(.easeInOut(duration: 0.3)) {}
        }
    }

    // MARK: - Error message
    private func errorView(_ error: String) -> some View {
        VStack(spacing: 12) {
            Text("⚠️ \(error)")
                .foregroundColor(.red)
                .transition(.opacity)
            Button("Retry") {
                Task { await viewModel.loadCharacters() }
                withAnimation(.easeInOut) {}
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    // MARK: - Filter search
    private var filteredCharacters: [Character] {
        if searchText.isEmpty {
            return viewModel.characters
        } else {
            return viewModel.characters.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
