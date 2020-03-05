//
//  NetworkService.swift
//  Practice2
//
//  Created by Anton Pryakhin on 03.03.2020.
//

import Foundation

protocol NetworkServiceProtocol {
    func searchPerson(name: String, completion: @escaping (Result<[Person]?, Error>) -> Void)
}

struct PersonResponse: Decodable {
    let count: Int
    let next: String?
    let prev: String?
    let results: [Person]
}

class NetworkService: NetworkServiceProtocol {
    func searchPerson(name: String, completion: @escaping (Result<[Person]?, Error>) -> Void) {
        let value = name.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://swapi.co/api/people/?search=\(value)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            do {
                guard let data = data else { return }

                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let json = try decoder.decode(PersonResponse.self, from: data)
                
                completion(.success(json.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
