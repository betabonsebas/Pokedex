//
//  Pokemon.swift
//  Pokedex
//
//  Created by Sebastian Bonilla on 27/09/23.
//

import Foundation

struct Pokemon: Decodable {
    let name: String
    let sprites: Sprite
    let abilities: [AbilityWrapper]
    let baseExperience: Int

    enum CodingKeys: String, CodingKey {
        case name
        case sprites
        case abilities
        case baseExperience = "base_experience"
    }

    public var sprite: String {
        self.sprites.frontDefault
    }

    public var abilitiesNames: [String] {
        abilities.map{ $0.ability.name }
    }
}

struct Sprite: Decodable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct AbilityWrapper: Decodable {
    let ability: Ability
}

struct Ability: Decodable {
    let name: String
}
