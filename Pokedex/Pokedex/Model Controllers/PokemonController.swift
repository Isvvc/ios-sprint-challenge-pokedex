//
//  PokemonController.swift
//  Pokedex
//
//  Created by Isaac Lyons on 10/4/19.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkingError: Error {
    case noInput
    case noData
    case noBearer
    case serverError(Error)
    case statusCode(Int)
    case badDecode(Error)
}

class PokemonController {
    let baseURL = URL(string: "https://pokeapi.co")!
    
    var pokemonList: [Pokemon] = []
    
    func getPokemon(from name: String, completion: @escaping (Result<Pokemon, NetworkingError>) -> Void) {
        if name.isEmpty {
            completion(.failure(.noInput))
            return
        }
        
        let requestURL = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("v2")
            .appendingPathComponent("pokemon")
            .appendingPathComponent(name)
        
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if let error = error {
                completion(.failure(.serverError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                completion(.success(pokemon))
            } catch {
                completion(.failure(.badDecode(error)))
            }
        }.resume()
    }
}