//
//  MainCoordinator.swift
//  Pokedex
//
//  Created by Sebastian Bonilla on 26/09/23.
//

import UIKit

class MainCoordinator: Coordinator {

    var presenter: UINavigationController

    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    func navigate() {
        let vc = MainViewController.fromStoryboard()
        vc.viewModel = MainViewModel()
        presenter.pushViewController(vc, animated: true)
    }
}
