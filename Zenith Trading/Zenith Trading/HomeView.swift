//
//  HomeView.swift
//  Zenith Trading
//
//  Created by Samyack on 28/05/26.
//

import SwiftUI
import SDWebImageSwiftUI

enum Tab {
    case home
    case positions
    case profile
}

struct HomeView: View {
    
    @State private var selectedTab: Tab = .home   
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            LiveStockView(selectedTab: $selectedTab)
                .tag(Tab.home)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            OpenPositionView()
                .tag(Tab.positions)
                .tabItem {
                    Label("Positions", systemImage: "text.document")
                }
            
            ProfileView()
                .tag(Tab.profile)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct LiveStockView: View {
    
    @StateObject private var vm = CoinsViewModel()
    @State private var currentCoin: Coins?
    @State private var goToPosition = false
    @State var coinError: Bool = false
    @Binding var selectedTab: Tab
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                    .blur(radius: 10)
                    .opacity(0.8)
                
                if vm.isLoading {
                    ProgressView("Loading...")
                        .tint(.white)
                    AnimatedImage(name: "loadingHand.gif")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                }
                
                
                
                VStack {
                    List {
                        ForEach(vm.coins) { coin in
                            CoinRowView(coin: coin)
                                .onTapGesture {
                                    currentCoin = coin
                                }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationBarBackButtonHidden(true)
            .sheet(item: $currentCoin) { coin in
                CoinDetailView(
                    coinName: coin.name,
                    image: coin.image,
                    currentPrice: coin.currentPrice,
                    onTradeComplete: {
                        currentCoin = nil   // close sheet
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            selectedTab = .positions
                        }
                    }
                )
            }
        }
        .task {
            await vm.fetchCoins()
        }
    }
}

struct CoinRowView: View {
    
    let coin: Coins
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: "\(coin.image)"))
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(.circle)
            // MARK: - Left Side
            VStack(alignment: .leading) {
                Text(coin.symbol.uppercased())
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(coin.name)
                    .font(.caption)
                    .foregroundStyle(.black)
            }
            
            Spacer()
            
            // MARK: - Right Side
            VStack(alignment: .trailing) {
                Text("$\(coin.currentPrice, specifier: "%.2f")")
                    .foregroundColor(Color(red: 0.071, green: 0.49, blue: 0.086))
                
                HStack {
                    Text("\(coin.priceChange24H, specifier: "%.2f")")
                        .font(.caption)
                    
                    Text("\(coin.priceChangePercentage24H, specifier: "%.2f")%")
                        .font(.caption)
                        .foregroundColor(priceColor)
                }
            }
        }
        .padding(.vertical, 4)
        .listRowBackground(
            LinearGradient(
                colors: [
                    Color(red: 0.682, green: 0.525, blue: 0.145),
                    Color(red: 0.969, green: 0.937, blue: 0.541),
                    Color(red: 0.824, green: 0.675, blue: 0.278)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .opacity(0.5)
        )
    }
    
    // MARK: - Computed Property (reduces compiler load)
    private var priceColor: Color {
        coin.priceChangePercentage24H >= 0 ? Color(red: 0.071, green: 0.49, blue: 0.086) : .red
    }
}


#Preview {
    HomeView()
}
