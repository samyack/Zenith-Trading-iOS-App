//
//  CoinsViewModel.swift
//  Zenith Trading
//
//  Created by Samyack on 28/05/26.
//

import Foundation
import SwiftUI

@MainActor
class CoinsViewModel: ObservableObject {
    
    @Published var coins: [Coins] = []
    @Published var isLoading: Bool = false
    
    func fetchCoins() async {
        isLoading = true
        coins = await APIService.shared.fetchCoinsDetails()
        isLoading = false
    }
    func getPrice(for coinName: String) -> Double {
        coins.first(where: { $0.name == coinName })?.currentPrice ?? 0
    }
    
}
