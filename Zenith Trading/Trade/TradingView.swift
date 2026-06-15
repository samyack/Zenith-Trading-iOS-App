//
//  TradingView.swift
//  Zenith Trading
//
//  Created by Samyack on 01/06/26.
//


import SwiftUI
import SDWebImageSwiftUI

struct TradingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var coinName: String
    var image: String
    var currentPrice: Double
    var onTrade: () -> Void
    
    @StateObject private var vm = TradingViewModel()
    @StateObject private var profileVM = ProfileViewModel()
    @State private var showOrderExecuted = false
    
    var body: some View {
        
        NavigationStack {
        ZStack {
            Image("bg")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .blur(radius: 10)
            
            VStack {
                VStack(alignment: .leading) {
                    HStack{
                        WebImage(url: URL(string: image))
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(.circle)
                        
                        Text(coinName)
                            .font(.title2)
                    }
                    
                    Text("\(currentPrice, specifier: "%.2f")")
                        .font(.largeTitle)
                        .bold()
                }
                Spacer()
                
                Picker(selection: $vm.tradeIn) {
                    Text("Buy")
                        .tag(0)
                        .font(.largeTitle)
                        .foregroundStyle(.blue)
                    Text("Sell").tag(1)
                }
                label: {
                    Text("Trade")
                }
                .pickerStyle(.segmented)
                .font(.largeTitle)
                .padding()
                
                
                
                Text("Units")
                    .font(.title2)
                    .bold()
                
                TextField("", value: $vm.tradeInUnits, format: .number)
                    .padding(10)
                    .keyboardType(.numberPad)
                    .background(.black.opacity(0.5))
                    .foregroundStyle(.white)
                    .frame(width: 150)
                    .cornerRadius(20)
                
                Text("USD $ value: \(vm.calculateTotal(price: currentPrice), specifier: "%.2f")")
                Text("Available Margin: \(profileVM.user?.money ?? 404, specifier: "%.2f")")
                
                if let money = profileVM.user?.money {
                    if money  >= vm.calculateTotal(price: currentPrice) {
                        GlassButton(title: vm.tradeIn == 0 ? "BUY" : "SELL") {
                            vm.saveTrade(
                                coinName: coinName,
                                currentPrice: currentPrice
                            ) {
                                showOrderExecuted.toggle()
                            }
                            
                        }
                        
                    } else {
                       
                        GlassButton(title: "Not Enough Funds") {
                            
                        }
                        .disabled(true)
                        

                    }
                } else {
                    ProgressView("Fteching User Details...")
                }
             
                
                
                
                Spacer()
            }
            .padding(30)
            
        }
        .onAppear {
            profileVM.fetchUser()
        }
        .navigationDestination(isPresented: $showOrderExecuted) {
            OrderExecutionView {
                dismiss()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    onTrade()
                }
            }
        }
        
    }
    }
}


#Preview {
    TradingView(coinName: "BTC", image: "", currentPrice: 100, onTrade: {  })
}
