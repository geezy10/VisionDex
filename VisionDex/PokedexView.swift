//
//  PokedexView.swift
//  VisionDex
//
//  Created by Gruber Raphael - s2310237024 on 28.11.25.
//
import SwiftUI

struct PokedexView: View {
    @Environment(AppModel.self) var appModel

    var body: some View {
        NavigationStack {
            List(appModel.pokedex) { pokemon in
                HStack {
                    Image(systemName: pokemon.isCaught ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(pokemon.isCaught ? .green : .gray)
                        .font(.title2)
                    
                    VStack(alignment: .leading) {
                        Text(pokemon.name)
                            .font(.headline)
                            .strikethrough(!pokemon.isCaught)
                            .opacity(pokemon.isCaught ? 1.0 : 0.5)
                        
                        if pokemon.isCaught {
                            Text("Gefangen!")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("Pokemon unbekannt")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    
                    if pokemon.isCaught {
                        Image(systemName: "cube_transparent")
                            .font(.largeTitle)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Pokédex")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Schließen") {
                        appModel.isPokedexOpen = false
                    }
                }
            }
        }
        .frame(minWidth: 400, minHeight: 600)
    }
}
