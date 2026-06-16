//
//  APIService.swift
//  Zenith Trading
//
//  Created by Samyack on 28/05/26.
//

import Foundation
import Combine


final class APIService {
    static let shared = APIService()
    
    private init() { }
    //MARK: - Fetch Coints current val without API Key
    
    func fetchCoinsDetails() async -> [Coins] {
        
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&category=layer-1&price_change_percentage=1h&precision=3")
        
        guard let url = url else { return [] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([Coins].self, from: data)
            return decoded
        } catch {
            
            print("API Services Error: \(error.localizedDescription)")
            return []
        }
    }
    
    
    //MARK: - Chart Fetch
    func fetchChartDetails(coinId: String) async -> [PricePoint] {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coinId.lowercased())/market_chart?vs_currency=usd&days=1") else {
            return []
        }
//        print("URL : \(url)")
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
//            let jsonString = String(data: data, encoding: .utf8)
//            print("RAW RESPONSE:", jsonString ?? "nil")
            
            let decoded = try JSONDecoder().decode(ChartResponse.self, from: data)
       
            let points: [PricePoint] = decoded.prices.map {
                PricePoint(
                    time: Date(timeIntervalSince1970: $0[0] / 1000),
                    price: $0[1]
                )
            }
            return points
            
        } catch {
            
            print("API Chart Error:", error)
            return []
        }
    }
    
    

