//
//  OpenPositionView.swift
//  Zenith Trading
//
//  Created by Samyack on 01/06/26.
//

import SwiftUI


struct OpenPositionView: View {
    
    @StateObject private var vm = OpenPositionViewModel()
    @StateObject private var coinVM = CoinsViewModel()
    @StateObject private var pVM = ProfileViewModel()
    
    @State private var selectedTrade: TradeModel?
    @State var timer: Timer?
    
    var totalUnrealisedPnL: Double {
        vm.trades.reduce(0) { total, trade in
            let currentPrice = coinVM.getPrice(for: trade.coinName)
            let pnl = vm.calculatePnL(trade: trade, currentPrice: currentPrice)
            return total + pnl
        }
    }
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                    .blur(radius: 10)
                
                VStack {

                    OpenPosContainerBox(unrealisedPnL: totalUnrealisedPnL)
                    
                    FloatingGlassPanel {
                        TradeListView(
                            trades: vm.trades,
                            coinVM: coinVM,
                            vm: vm
                        ) { trade in
                            selectedTrade = trade
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .sheet(item: $selectedTrade) { trade in
                PositionDetailView(trade: trade)
            }
        }
        .task {
            await vm.fetchTrades()
            await coinVM.fetchCoins()
            print(".task refreshed")
        }
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 20.0, repeats: true) { _ in
                Task {
                    await vm.fetchTrades()
                    await coinVM.fetchCoins()
                }
                print("refreshed")
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
}

struct TradeListView: View {
    
    let trades: [TradeModel]
    let coinVM: CoinsViewModel
    let vm: OpenPositionViewModel
    var onSelect: (TradeModel) -> Void
    
    var body: some View {
        List {
            ForEach(trades) { trade in
                
                let currentPrice = coinVM.getPrice(for: trade.coinName)
                let pnl = vm.calculatePnL(trade: trade, currentPrice: currentPrice)
                
                TradeRowView(
                    trade: trade,
                    currentPrice: currentPrice,
                    pnl: pnl
                )
                .listRowBackground(Color.clear)
                .onTapGesture {
                    onSelect(trade)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}


struct TradeRowView: View {
    
    let trade: TradeModel
    let currentPrice: Double
    let pnl: Double
    
    var body: some View {
        HStack {
            
            VStack(alignment: .leading) {
                Text(trade.coinName)
                    .font(.headline)
                
                Text("Price: \(currentPrice, specifier: "%.2f")")
            }
            
            Spacer()
            
            VStack(alignment: .trailing){
                
                Text("\(pnl, specifier: "%.2f")")
                    .foregroundColor(pnl >= 0 ? .green : .red)
                
                Text(trade.type != 0 ? "S" : "B")
                    .font(.caption)
                    .padding(3)
                    .background((trade.type != 0) ? .red : .blue )
                    .cornerRadius(20)
            }
        }
    }
}

struct OpenPosContainerBox: View {
    
    var unrealisedPnL: Double
    
    var body: some View {
        VStack {
            FloatingGlassPanel {
                
                Text("Positions")
                    .font(.headline.bold())
                
                VStack {
                    Text("$ \(unrealisedPnL, specifier: "%.2f")")
                        .font(.title2.bold())
                        .foregroundStyle(unrealisedPnL >= 0 ? .green : .red)
                    
                    Text("Unrealised P&L")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
    }
}


#Preview {
    OpenPositionView()
}
