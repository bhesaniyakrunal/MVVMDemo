//
//  Model.swift
//  MVVMDemo
//
//  Created by MacBook on 11/19/24.
//

import Foundation

// MARK: - Models
struct Product: Decodable {
    let id: String
    let name: String
    let data: ProductData?
}

struct ProductData: Decodable {
    let color: String?
    let capacity: String?
    let capacityGB: Int?
    let price: Double?
    let generation: String?
    let year: Int?
    let cpuModel: String?
    let hardDiskSize: String?
    let strapColour: String?
    let caseSize: String?
    let description: String?

    // Custom keys to handle inconsistent JSON keys
    enum CodingKeys: String, CodingKey {
        case color, capacity, price, generation, year
        case capacityGB = "capacity GB"
        case cpuModel = "CPU model"
        case hardDiskSize = "Hard disk size"
        case strapColour = "Strap Colour"
        case caseSize = "Case Size"
        case description = "Description"
    }
}
