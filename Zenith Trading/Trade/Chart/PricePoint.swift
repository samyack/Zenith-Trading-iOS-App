//
//  PricePoint.swift
//  Zenith Trading
//
//  Created by Samyack on 12/06/26.
//

import Foundation

struct PricePoint: Identifiable {
    let id = UUID()
    let time: Date
    let price: Double
}

struct ChartResponse: Decodable {
    let prices: [[Double]]
}

