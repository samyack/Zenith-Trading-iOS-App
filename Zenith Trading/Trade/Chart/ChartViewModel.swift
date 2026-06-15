//
//  ChartViewModel.swift
//  Zenith Trading
//
//  Created by Samyack on 15/06/26.
//

import Foundation

@MainActor
class ChartViewModel: ObservableObject {
    
    @Published var points: [PricePoint] = []
    
    func loadChart(coinId: String) async {
        let result = await APIService.shared.fetchChartDetails(coinId: coinId)
        self.points = result
    }
}


