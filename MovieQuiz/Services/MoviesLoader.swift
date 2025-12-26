//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Максим Беспалов on 23.12.2025.
//
import UIKit

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader : MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    // MARK: - URL
       private var mostPopularMoviesUrl: URL {
           guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
               preconditionFailure("Unable to construct mostPopularMoviesUrl")
           }
           return url
       }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, any Error>) -> Void) {
        let onResponseReceived: ((Result<Data, Error>) -> Void) = { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
                
            case .success(let data):
                do {
                    let movies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(movies))
                } catch {
                    print("Failed to parse MostPopularMovies response: \(error.localizedDescription)")
                    handler(.failure(error))
                }
            }
        }
        networkClient.fetch(url: mostPopularMoviesUrl, handler: onResponseReceived)
    }
}
