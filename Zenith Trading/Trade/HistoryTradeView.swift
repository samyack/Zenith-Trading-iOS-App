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
            Text("Trade History")
                .font(.largeTitle)
                .bold()
            FloatingGlassPanel {
                List {
                    ForEach(vm.trades) { trade in
                        HStack {
                            Text(trade.coinName)
                                .font(.title)
                            Spacer()
                            Text("\(trade.exitedAt, specifier: "%.2f")")
                                .font(.title)
                                .foregroundStyle(trade.exitedAt >= 0 ? .green : .red)
                                .bold()
                        }
                        
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
        .padding(20)
        .task {
            await vm.tradeHistory()
        }
    }
}







#Preview {
    HistoryTradeView()
}
