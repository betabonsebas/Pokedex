//
//  NetworkProvider.swift
//  Pokedex
//
//  Created by Sebastian Bonilla on 27/09/23.
//

import Foundation
import Alamofire

class NetworkProvider {
    func fetch<T>(completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        AF.request("https://pokeapi.co/api/v2/pokemon/25")
            .responseDecodable(completionHandler: { (data: DataResponse<T, AFError>) in
                debugPrint(data)
                switch data.result {
                case .success(let entity):
                    completion(.success(entity))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
    }
}
