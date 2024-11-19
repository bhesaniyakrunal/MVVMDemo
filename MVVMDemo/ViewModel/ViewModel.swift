//
//  ViewModel.swift
//  MVVMDemo
//
//  Created by MacBook on 11/19/24.
//
import Foundation

class ProductViewModel {
    private let networkManager: NetworkManagerProtocol

    // Dependency Injection via initializer
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchProducts(completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        let url = "https://api.restful-api.dev/objects"

        // Validate the URL format before making the request
        guard URL(string: url) != nil else {
            completion(.failure(.invalidURL))
            return
        }

        networkManager.request(
            url: url,
            method: .GET,
            headers: [:], body: nil,
            responseType: [Product].self,
            completion: completion
        )
    }
}
