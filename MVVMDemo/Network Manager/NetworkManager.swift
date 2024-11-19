//
//  NetworkManager.swift
//  MVVMDemo
//
//  Created by MacBook on 11/19/24.
//

import Foundation

// MARK: - HTTPMethod Enum
enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS, TRACE
}

// MARK: - NetworkError Enum
enum NetworkError: Error {
    case invalidURL
    case responseError
    case decodingError
    case unknown
}

// MARK: - Protocol for Dependency Inversion
protocol NetworkManagerProtocol {
    func request<T: Decodable>(
            url: String,
            method: HTTPMethod,
            headers: [String: String]?,
            body: Data?,
            responseType: T.Type,
            completion: @escaping (Result<T, NetworkError>) -> Void
        )
}


// MARK: - NetworkManager Class
class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private init() {}

    func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        headers: [String: String]? = nil, // Default value provided here
        body: Data? = nil,               // Default value provided here
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let requestURL = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(.responseError))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.responseError))
                return
            }

            guard let data = data else {
                completion(.failure(.unknown))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(.decodingError))
            }
        }

        task.resume()
    }
}

