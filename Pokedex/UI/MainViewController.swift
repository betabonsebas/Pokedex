//
//  ViewController.swift
//  Pokedex
//
//  Created by Sebastian Bonilla on 26/09/23.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var abilitiesStackView: UIStackView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var experienceLabel: UILabel!

    var viewModel: MainViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        viewModel.title
            .subscribe { [weak self] event in
                self?.title = event.element
            }
            .disposed(by: viewModel.disposeBag)

        viewModel.abilities
            .subscribe { [weak self] event in
                guard let abilities = event.element else { return }
                self?.buildAbilities(abilities)
            }
            .disposed(by: viewModel.disposeBag)

        viewModel.experience
            .subscribe { [weak self] event in
                guard let experience = event.element else { return }
                self?.experienceLabel.text = "\(experience)"
            }
            .disposed(by: viewModel.disposeBag)

        viewModel.picture
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                guard let picture = event.element else { return }
                self?.pokemonImageView.image = picture
            }
            .disposed(by: viewModel.disposeBag)

        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                guard let isLoading = event.element else { return }
                self?.loadingIndicator.isHidden = !isLoading
            }
            .disposed(by: viewModel.disposeBag)
    }

    private func buildAbilities(_ abilities: [String]) {
        for ability in abilities {
            let label = UILabel(frame: .zero)
            label.text = "-\t\(ability)"
            label.translatesAutoresizingMaskIntoConstraints = false
            abilitiesStackView.addArrangedSubview(label)
        }
    }

    @IBAction func decreaseExperienceAction(_ sender: Any) {
        viewModel.decreaseExperience()
    }

    @IBAction func increaseExperienceAction(_ sender: Any) {
        viewModel.increaseExperience()
    }

}

