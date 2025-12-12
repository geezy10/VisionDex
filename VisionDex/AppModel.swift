//
//  AppModel.swift
//  VisionDex
//
//  Created by Gottlieb-Zimmermann Niklas - s2310237011 on 21.11.25.
//

import SwiftUI

///Data object for a pokemon
struct PokemonData: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var isCaught: Bool = false
    let imageName: String
}

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    
    var pokedex: [PokemonData] = [
        PokemonData(name: "Pikachu", imageName: "pikachu"),
        PokemonData(name: "Bisasam", imageName: "bisasam"),
        PokemonData(name: "Glumanda", imageName: "glumanda"),
        PokemonData(name: "Shiggy", imageName: "shiggy"),
        PokemonData(name: "Relaxo", imageName: "relaxo"),
        PokemonData(name: "Dragoran", imageName: "dragoran")
    ]
    
    var isPokedexOpen: Bool = false
    
    ///Logic for catching
    func catchPokemon(name: String) {
        if let index = pokedex.firstIndex(where: { $0.name == name }) {
            pokedex[index].isCaught = true
            print("\(name) wurde gefangen und im Pokedex registriert!")
        }
    }
    
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
}
