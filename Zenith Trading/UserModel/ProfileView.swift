//
//  ProfileView.swift
//  Zenith Trading
//
//  Created by Samyack on 28/05/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @StateObject private var vm = ProfileViewModel()
    @StateObject var authViewModel  = AuthViewModel()
    @StateObject private var openPosVM = OpenPositionViewModel()
    @State var open = OpenPositionView()

    @StateObject private var coinVM = CoinsViewModel()
    
    var totalUnrealisedPnL: Double {
        openPosVM.trades.reduce(0) { total, trade in
            let currentPrice = coinVM.getPrice(for: trade.coinName)
            let pnl = openPosVM.calculatePnL(trade: trade, currentPrice: currentPrice)
            return total + pnl
        }
    }

    
    var body: some View {
        NavigationStack {
        ZStack {
            
            Image("bg")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .blur(radius: 10)
            
            if vm.isLoading {
                ProgressView("Loading...")
                    .tint(.white)
            AnimatedImage(name: "loadingHand.gif")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
            
            // MARK: - Settings Button
            
            VStack(spacing: 20) {
                if let user = vm.user {
                HStack {
                    Text("\(user.name)")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white)
                    Spacer()
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .font(.largeTitle)
                            .scaledToFit()
                            .frame(width: 30,height: 30)
                            .foregroundStyle(.white)
                    }
                    

                }
                .padding()
                
                // MARK: - User Name
               
                   
                    ContainerBox(margin: user.money, unrealisedPnL: totalUnrealisedPnL)
                    
            
                    
                } else {
                    Text("No user data")
                        .foregroundStyle(.white)
                    ContainerBox(margin: 10000, unrealisedPnL: 300)
                }
                
                Spacer()

                
            }
            .padding()
        }
       
    }
        .onAppear {
            vm.fetchUser()
            Task {
                    await openPosVM.fetchTrades()
                    await coinVM.fetchCoins()
                }
        }
    }
}

struct ContainerBox: View {
    
    var margin: Double
    var unrealisedPnL: Double
    
    var body: some View {
        
            VStack {
                FloatingGlassPanel {
                    Text("Portfolio")
                        .font(.headline.bold())
                    HStack {
                        VStack{
                            Text("$ \(margin, specifier: "%.2f")")
                                .font(.title2.bold())
                            Text("Total Available Margin")
                                .font(.caption2)
                                .foregroundStyle(.secondary)

                        }
                        Spacer()
                        VStack {
                            Text("$ \(unrealisedPnL, specifier: "%.2f")")
                                .font(.title2.bold())
                                .foregroundStyle(unrealisedPnL >= 0 ? .green : .red)
                            Text("Unrealised P&N")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                       
                    }
                    .padding()
                }
                .padding()
               
            }
    
    }
}
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}


struct FloatingGlassPanel<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            content()
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .yellow.opacity(0.5), radius: 30, y: 14)
    }
}


struct GlassButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .padding(.horizontal, 26)
                .padding(.vertical, 14)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .blue.opacity(0.35), radius: 20)
        }
    }
}

//MARK: - Settings View
struct SettingsView: View {
    @StateObject var authViewModel  = AuthViewModel()

    var body: some View {
        VStack {
            List {
                //MARK: - Sign Out
                Button {
                    authViewModel.signOut()
                } label: {
                    Text("Signout")
                }
                
                NavigationLink(destination: {
                    HistoryTradeView()
                }, label: {
                    Image(systemName: "gobackward")
                    Text("History")
                })
                
                .navigationDestination(isPresented: $authViewModel.isSignedOut) {
                    LoginView()
                }
                
            }
        }
    }
}


#Preview {
    ProfileView()
}
