//
//  TradingViewModel.swift
//  Zenith Trading
//
//  Created by Samyack on 01/06/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class TradingViewModel: ObservableObject {
    
    @Published var tradeIn: Int = 0
    @Published var tradeInUnits: Int = 1
    
    
    // MARK: - Computed total price
    func calculateTotal(price: Double) -> Double {
        (price / 500) * Double(tradeInUnits)
    }
    
    // MARK: - Save Trade
    func saveTrade(
        coinName: String,
        currentPrice: Double,
        completion: @escaping () -> Void
    ) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No user logged in")
            return
        }
        
        var totalPrice = calculateTotal(price: currentPrice)
        totalPrice = (totalPrice * 100).rounded() / 100
        let db = Firestore.firestore()
        
        let tradeData: [String: Any] = [
            "coinName": coinName,
            "buyOrSell": tradeIn,
            "units": tradeInUnits,
            "entryPrice": currentPrice,
            "totalPrice": totalPrice,
            "timestamp": Timestamp(),
            "isOpen" : true,         // added this
            "exitedAt" : 0.0
        ]
        
        db.collection("users")
            .document(uid)
            .collection("trades")
            .addDocument(data: tradeData) { error in
                
                if let error = error {
                    print("Trade save failed: \(error)")
                } else {
                    
                    print("Trade saved successfully")
                    completion()
                }
            }
            

        Task {
            await updateBalance(totalPrice: totalPrice)
            print("called update Balance")
        }
        
    }
    
    func updateBalance(totalPrice: Double) async {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No user logged in")
            return
        }
        let db = Firestore.firestore()
        
        let updateValue = db.collection("users").document(uid)
        do {
            try await updateValue.updateData([
                "money" : FieldValue.increment(-totalPrice)
            ])
            print("Updated money")
        } catch {
            print("Error while updating money \(error)")
        }
        
    }
    
}
