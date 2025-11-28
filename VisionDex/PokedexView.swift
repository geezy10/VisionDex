//
//  PokedexView.swift
//  VisionDex
//
//  Created by Gruber Raphael - s2310237024 on 28.11.25.
//
/*import SwiftUI

struct PokedexView: View {
    @Environment(AppModel.self) var appModel

    var body: some View {
        NavigationStack {
            List(appModel.pokedex) { pokemon in
                HStack {
                    Image(systemName: pokemon.isCaught ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(pokemon.isCaught ? .green : .gray)
                    
                    VStack(alignment: .leading) {
                        Text(pokemon.name)
                            .font(.headline)
                            .foregroundStyle(pokemon.isCaught ? .primary : .secondary)
                        
                        if pokemon.isCaught {
                            Text(pokemon.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("???")
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("Pokédex")
        }
    }
}*/
