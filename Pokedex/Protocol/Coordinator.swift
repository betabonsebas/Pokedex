//
//  Coordinator.swift
//  Pokedex
//
//  Created by Sebastian Bonilla on 26/09/23.
//

import UIKit

protocol Coordinator {
    var presenter: UINavigationController { get }

    func navigate()
}
