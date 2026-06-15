//
//  ProfileViewModel.swift
//  Zenith Trading
//
//  Created by Samyack on 01/06/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    
    @Published var user: UserModel?
    @Published var isLoading: Bool = false
    
    private let db = Firestore.firestore()
    
    func fetchUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No user logged in")
            return
        }
        
        isLoading = true
        
        db.collection("users")
            .document(uid)
            .getDocument { snapshot, error in
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                if let error = error {
                    print("Error fetching user: \(error)")
                    return
                }
                
                guard let data = snapshot?.data() else {
                    print(" No user data found")
                    return
                }
                
                let name = data["name"] as? String ?? "No Name"
                let money = data["money"] as? Double ?? 0.0
                
                DispatchQueue.main.async {
                    self.user = UserModel(
                        id: uid,
                        name: name,
                        money: money
                    )
                }
            }
    }
}
