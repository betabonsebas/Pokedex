//
//  ImageLoader.swift
//  Pokedex
//
//  Created by Sebastian Bonilla on 28/09/23.
//

import UIKit

class ImageLoader {
    static let shared = ImageLoader()

    private var loadedImages = [String: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()

    func loadImage(_ url: String, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {

      if let image = loadedImages[url] {
        completion(.success(image))
        return nil
      }

      let uuid = UUID()

      let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
        defer {self.runningRequests.removeValue(forKey: uuid) }

        if let data = data, let image = UIImage(data: data) {
          self.loadedImages[url] = image
          completion(.success(image))
          return
        }

        guard let error = error else {
          return
        }

        guard (error as NSError).code == NSURLErrorCancelled else {
          completion(.failure(error))
          return
        }
      }
      task.resume()

      runningRequests[uuid] = task
      return uuid
    }

    func cancelLoad(_ uuid: UUID) {
      runningRequests[uuid]?.cancel()
      runningRequests.removeValue(forKey: uuid)
    }
}
