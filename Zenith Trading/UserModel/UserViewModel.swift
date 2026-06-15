//
//  UserViewModel.swift
//  Zenith Trading
//
//  Created by Samyack on 01/06/26.
//

import Foundation
//import FirebaseFirestore
//import FirebaseAuth
//
//@Published var user: UserModel?
//
//func fetchUser() {
//    
//    guard let uid = Auth.auth().currentUser?.uid else { return }
//    
//    Firestore.firestore()
//        .collection("users")
//        .document(uid)
//        .getDocument { snapshot, error in
//            
//            if let data = snapshot?.data() {
//                
//                let name = data["name"] as? String ?? ""
//                let money = data["money"] as? Double ?? 0
//                
//                DispatchQueue.main.async {
//                    self.user = UserModel(name: name, money: money)
//                }
//            }
//        }
//}
