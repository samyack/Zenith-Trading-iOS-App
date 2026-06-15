//
//  HistoryTradeView.swift
//  Zenith Trading
//
//  Created by Samyack on 12/06/26.
//

import SwiftUI

struct HistoryTradeView: View {
    
    @StateObject private var vm = OpenPositionViewModel()
    @StateObject private var coinVM = CoinsViewModel()

    
    var body: some View {
        VStack {
            FloatingGlassPanel {
                List {
                    ForEach(vm.trades) { trade in
                        HStack {
                            Text(trade.coinName)
                                .font(.headline)
                            Spacer()
                            Text("+10")
                        }
                        
                    }
                }
            }
        }
        .task {
            await vm.tradeHistory()
//            await coinVM.fetchCoins()
        }
    }
}







#Preview {
    HistoryTradeView()
}
