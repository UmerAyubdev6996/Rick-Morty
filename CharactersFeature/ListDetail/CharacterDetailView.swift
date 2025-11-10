//
//  CharacterDetailView.swift
//  AssignmentApp
//
//  Created by Umer Ayub on 08/11/2025.
//

import SwiftUI
import Models
import SDWebImageSwiftUI

public struct CharacterDetailView: View {
    @ObservedObject var viewModel: CharacterDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var fadeIn = false

    public init(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    WebImage(url: viewModel.character.imageURL)
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade(duration: 0.3))
                        .scaledToFill()
                        .frame(width: geometry.size.width,
                               height: max(geometry.size.height, 300))
                        .clipped()
                        .overlay(
                            LinearGradient(
                                colors: [.black.opacity(0.4), .clear],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                        .offset(y: -geometry.frame(in: .global).minY)
                        .opacity(fadeIn ? 1 : 0)
                        .animation(.easeOut(duration: 0.6), value: fadeIn)
                }
                .frame(height: 300)
                .ignoresSafeArea(edges: .top)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(viewModel.character.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .opacity(fadeIn ? 1 : 0)
                                .offset(y: fadeIn ? 0 : 15)
                                .animation(.easeInOut(duration: 0.5).delay(0.2), value: fadeIn)

                            HStack(spacing: 10) {
                                statusDot
                                Text(viewModel.character.status)
                                Text("•")
                                Text(viewModel.character.species)
                            }
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .opacity(fadeIn ? 1 : 0)
                            .animation(.easeInOut(duration: 0.4).delay(0.3), value: fadeIn)
                        }

                        Spacer()
                    }

                    Divider().padding(.vertical, 4)

                    VStack(alignment: .leading, spacing: 8) {
                        infoRow(title: "Gender", value: viewModel.character.gender)
                        infoRow(title: "Origin", value: viewModel.character.originName)
                        infoRow(title: "Location", value: viewModel.character.locationName)
                    }
                    .opacity(fadeIn ? 1 : 0)
                    .animation(.easeIn(duration: 0.4).delay(0.4), value: fadeIn)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2)
                )
                .offset(y: -24)
            }
        }
        .onAppear { fadeIn = true }
        .ignoresSafeArea(edges: .top)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation(.easeInOut) {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .scaleEffect(fadeIn ? 1 : 0.7)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: fadeIn)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var statusDot: some View {
        Circle()
            .fill(statusColor)
            .frame(width: 14, height: 14)
    }

    private var statusColor: Color {
        switch viewModel.character.status.lowercased() {
        case "alive": return .green
        case "dead": return .red
        default: return .gray
        }
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title + ":")
                .fontWeight(.semibold)
            Text(value)
        }
        .foregroundColor(.primary)
    }
}
