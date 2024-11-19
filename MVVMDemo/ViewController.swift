//
//  ViewController.swift
//  MVVMDemo
//
//  Created by MacBook on 11/19/24.
//

import UIKit

class ViewController: UIViewController {
    private var viewModel: ProductViewModel!
    private var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Injecting dependency
        viewModel = ProductViewModel(networkManager: NetworkManager.shared)
        
        fetchProducts()
    }

    private func fetchProducts() {
        viewModel.fetchProducts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self?.products = products
                    self?.displayProducts()
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }

    private func displayProducts() {
        products.forEach { product in
            print("ID: \(product.id), Name: \(product.name)")
            if let data = product.data {
                print("   Data: \(data)")
            }
        }
    }

    private func handleError(_ error: NetworkError) {
        let errorMessage: String
        switch error {
        case .invalidURL:
            errorMessage = "Invalid URL. Please check and try again."
        case .responseError:
            errorMessage = "Failed to fetch products. Please try again later."
        case .decodingError:
            errorMessage = "Failed to process the server response. Please report the issue."
        case .unknown:
            errorMessage = "An unknown error occurred."
        }

        print("Error: \(errorMessage)")
        // You can display an alert here for better UX
    }
}


