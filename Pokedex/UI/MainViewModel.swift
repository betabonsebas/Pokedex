//
//  MainViewModel.swift
//  Pokedex
//
//  Created by Sebastian Bonilla on 26/09/23.
//

import UIKit
import Combine
import RxSwift
import RxCocoa

class MainViewModel: ObservableObject {
    let disposeBag = DisposeBag()

    private var pokemon = PublishRelay<Pokemon>()
    private var networkProvider = NetworkProvider()

    var title = PublishRelay<String>()
    var picture = PublishRelay<UIImage>()
    var abilities = PublishRelay<[String]>()
    var experience = BehaviorRelay<Int>(value: 0)
    var isLoading = PublishRelay<Bool>()

    init() {
        pokemon
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                guard let p = event.element else {
                    return
                }
                self?.title.accept(p.name)
                self?.abilities.accept(p.abilities.map { $0.ability.name })
                self?.experience.accept(p.baseExperience)
                self?.fetchImage(p.sprite)
            }.disposed(by: disposeBag)
        fetchPokemon()
    }

    func fetchPokemon() {
        isLoading.accept(true)
        networkProvider.fetch { [weak self] (result: Result<Pokemon, Error>) in
            switch result {
            case .success(let success):
                self?.pokemon.accept(success)
            case .failure(let failure):
                debugPrint(failure)
            }
            self?.isLoading.accept(false)
        }
    }

    func fetchImage(_ imageURLString: String) {
        isLoading.accept(true)
        _ = ImageLoader.shared.loadImage(imageURLString) { [weak self] (result: Result<UIImage, Error>) in
            switch result {
            case .success(let image):
                self?.picture.accept(image)
            case .failure(let error):
                debugPrint(error)
            }
            self?.isLoading.accept(false)
        }
    }

    func increaseExperience() {
        experience.accept(experience.value + 1)
    }

    func decreaseExperience() {
        experience.accept(experience.value == 0 ? 0 : experience.value - 1)
    }
}
