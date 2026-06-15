//
//  CoinDetailView.swift
//  Zenith Trading
//
//  Created by Samyack on 28/05/26.
//
import SwiftUI
import SDWebImageSwiftUI
import Charts

struct CoinDetailView: View {
    
    var coinName: String
    var image: String
    var currentPrice: Double
    var onTradeComplete: () -> Void
    
    @State var tradingView: Bool = false
    @State private var goToPosition = false
    @StateObject var chartVM = ChartViewModel()
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                    .blur(radius: 10)
                
                VStack {
                    
                    VStack(alignment: .leading)  {
                        HStack{
                            WebImage(url: URL(string: image))
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(.circle)
                            
                            Text(coinName)
                                .font(.title2)
                        }
                    }
                    .padding(20)
                    
                    Text("\(currentPrice, specifier: "%.2f")")
                        .font(.largeTitle)
                        .bold()
                    
                    GlassButton(title: "Trade") {
                        tradingView.toggle()
                        
                    }
                    
                    if chartVM.points.isEmpty {
                        ProgressView("Loading Chart...")
                    }
                    else {
                        Chart(chartVM.points) { point in
                            LineMark(
                                x: .value("Time", point.time),
                                y: .value("Price", point.price)
                            )
                        }
                        .frame(width: 200,height: 200)
                        .padding(10)
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .task {
                await chartVM.loadChart(coinId: coinName)
            }
            
            // Navigate to TradingView
            .navigationDestination(isPresented: $tradingView) {
                TradingView(
                    coinName: coinName,
                    image: image,
                    currentPrice: currentPrice,
                    onTrade: {
                        onTradeComplete()
                    }
                )
            }
            
            // Navigate to OpenPositionView
            .navigationDestination(isPresented: $goToPosition) {
                OpenPositionView()
            }
        }
    }
}

//#Preview {
//    CoinDetailView(coinName: "bitcoin", image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400", currentPrice: 120.9)
//}
