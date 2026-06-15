//
//  Coins.swift
//  Zenith Trading
//
//  Created by Samyack on 28/05/26.
//

import Foundation

struct Coins: Codable, Identifiable, Hashable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let high24H, low24H, priceChange24H, priceChangePercentage24H: Double
    enum CodingKeys: String, CodingKey {
           case id, symbol, name, image
           case currentPrice = "current_price"
           case high24H = "high_24h"
           case low24H = "low_24h"
           case priceChange24H = "price_change_24h"
           case priceChangePercentage24H = "price_change_percentage_24h"
       }
}
