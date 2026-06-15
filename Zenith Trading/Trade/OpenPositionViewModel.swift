//
//  OpenPositionViewModel.swift
//  Zenith Trading
//
//  Created by Samyack on 01/06/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI


class OpenPositionViewModel: ObservableObject {
    
    @Published var trades: [TradeModel] = []
    var unrealisedPnL: Double = 0

    
    private let db = Firestore.firestore()
    
    // MARK: - Fetch trades
    func fetchTrades() async {
        guard let uid  = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users")
            .document(uid)
            .collection("trades")
            .whereField("isOpen", isEqualTo: true)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, _ in
                
                guard let docs = snapshot?.documents else { return }
                
                self.trades = docs.map({ doc in
                    
                    let data = doc.data()
                    
                    return TradeModel(id: doc.documentID,
                                      coinName: data["coinName"] as! String,
                                      type: data["buyOrSell"] as! Int,
                                      units: data["units"] as! Int,
                                      entryPrice: data["entryPrice"] as! Double,
                                      margin: data["totalPrice"] as! Double,
                                      isOpen: data["isOpen"] as! Bool
                    )
                })
                
            }
    }
    // MARK: - PnL
    func calculatePnL(trade: TradeModel, currentPrice: Double) -> Double {
        let leverage = 500.0
        
//        var uPnL = 0.0
        if trade.type == 0 {
            let pnl = ((currentPrice - trade.entryPrice) * Double(trade.units)) / leverage
//            print("Pnl \(pnl) )")
            return pnl
        } else {
            return ((trade.entryPrice - currentPrice) * Double(trade.units)) / leverage
        }
    }
    
    //MARK: - Exit Trade
    func exitPosition(trade: TradeModel,currentPrice: Double) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let pnl = calculatePnL(trade: trade, currentPrice: currentPrice)
        let finalPrice = trade.margin + pnl
        
        let userRef = db.collection("users").document(uid)
        let tradesRef = userRef.collection("trades").document(trade.id)
        
        db.runTransaction({ transaction, error in
            
            transaction.updateData(["isOpen" : false, "exitedAt" : pnl ], forDocument: tradesRef)
            
            
            transaction.updateData(["money" : FieldValue.increment(finalPrice)], forDocument: userRef)
            print("final Price \(finalPrice)")
            return nil
        }) { _, error in
            if let error = error {
                print("Exit failed: \(error)")
            } else {
                print("Trade exited successfully")
            }
            
        }
    }
    
    func calculateTotalPnL(using prices: [String: Double]) {
        let total = trades.reduce(0) { total, trade in
            let currentPrice = prices[trade.coinName] ?? 0
            let pnl = calculatePnL(trade: trade, currentPrice: currentPrice)
            return total + pnl
        }
        
        self.unrealisedPnL = total
    }
    
    
    // MARK: - Trade History
    func tradeHistory() async {
        guard let uid  = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users")
            .document(uid)
            .collection("trades")
            .whereField("isOpen", isEqualTo: false)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, _ in
                
                guard let docs = snapshot?.documents else { return }
                
                self.trades = docs.map({ doc in
                    
                    let data = doc.data()
                    
                    return TradeModel(id: doc.documentID,
                                      coinName: data["coinName"] as! String,
                                      type: data["buyOrSell"] as! Int,
                                      units: data["units"] as! Int,
                                      entryPrice: data["entryPrice"] as! Double,
                                      margin: data["totalPrice"] as! Double,
                                      isOpen: data["isOpen"] as! Bool
                    )
                })
                
            }
    }
        
    
}
