//
//  CharacterRow.swift
//  AssignmentApp
//
//  Created by Umer Ayub on 08/11/2025.
//

import SwiftUI
import Models
import SDWebImageSwiftUI

public struct CharacterRow: View {
    public let character: Character

    public init(character: Character) {
        self.character = character
    }

    public var body: some View {
        HStack(spacing: 16) {
            WebImage(url: character.imageURL)
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.3)) 
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(radius: 3)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                )

            VStack(alignment: .leading, spacing: 6) {
                Text(character.name)
                    .font(.headline)
                Text("\(character.status) • \(character.species)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Origin: \(character.originName)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            Circle()
                .fill(statusColor)
                .frame(width: 12, height: 12)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        )
    }

    private var statusColor: Color {
        switch character.status.lowercased() {
        case "alive": return .green
        case "dead": return .red
        default: return .gray
        }
    }
}

