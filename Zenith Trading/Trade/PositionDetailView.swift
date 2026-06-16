//
//  PositionDetailView.swift
//  Zenith Trading
//
//  Created by Samyack on 05/06/26.
//

import SwiftUI

struct PositionDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var vm = OpenPositionViewModel()
    @StateObject private var coinVM = CoinsViewModel()

    var trade: TradeModel
    
    var body: some View {
        VStack {
            Text("Trade Details")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 35)
            
            HStack {
                Text("Coin Traded:")
                Spacer()
                Text(trade.coinName)
            }
            HStack{
                Text("Status: ")
                Spacer()
                Text(trade.isOpen ? "Active" : "Closed")
            }
            HStack {
                Text("Entry Price:")
                Spacer()
                Text("\(trade.entryPrice, specifier: "%.2f")")
            }
            .padding(.bottom, 10)
            Divider()
            HStack {
                Text("Units: ")
                Spacer()
                Text("\(trade.units, specifier: "%.2f")")
            }
            .padding(.top, 10)
            HStack {
                Text("Margin Used: ")
                Spacer()
                Text("\(trade.margin, specifier: "%.2f")")
            }
            
//            Button {
//                let currentPrice = coinVM.getPrice(for: trade.coinName)
//                vm.exitPosition(trade: trade, currentPrice: currentPrice)
//                dismiss()
//            } label: {
//                Text("Exit")
//            }
            Spacer()
            GlassButton(title: "Exit") {
                let currentPrice = coinVM.getPrice(for: trade.coinName)
                vm.exitPosition(trade: trade, currentPrice: currentPrice)
                dismiss()
            }

        }
        .padding(30)
        .task {
            await coinVM.fetchCoins()
            await vm.fetchTrades()
        }
    }
}

//#Preview {
//    PositionDetailView(trade: .init(id: "1", coinName: "Bit", type: 1, units: 2, entryPrice: 100, margin: 200,isOpen: true))
//}
