//
//  AuthViewModel.swift
//  Zenith Trading
//
//  Created by Samyack on 27/05/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var user: User? = nil
       @Published var isSignedIn: Bool = false
    @Published var isSignedOut: Bool = false
    @Published var loginOrSignUpError: FirebaseError?

    let db = Firestore.firestore()
    
       init() {
           self.user = Auth.auth().currentUser
           self.isSignedIn = user != nil
       }

    func signUp(email: String, password: String, name: String) {
           Auth.auth().createUser(withEmail: email, password: password) { result, error in
               if let user = result?.user {
                           
                           let userData: [String: Any] = [
                               "name": name,
                               "money": 10000.0
                           ]
                           
                   self.db.collection("users").document(user.uid).setData(userData) { err in
                               if let err = err {
                                   self.loginOrSignUpError = FirebaseError(message: err.localizedDescription)
                                   print("Error creating user doc: \(err)")
                               } else {
                                   print("User doc created ✅")
                               }
                           }
                       }

               self.user = result?.user
               self.isSignedIn = true
           }
       }

       func signIn(email: String, password: String) {
           Auth.auth().signIn(withEmail: email, password: password) { result, error in
               if let error = error {
                   self.loginOrSignUpError = FirebaseError(message: error.localizedDescription)
                   print("Sign In Error: \(error.localizedDescription)")
                   return
               }
               self.user = result?.user
               self.isSignedIn = true
           }
       }

       func signOut() {
           do {
               try Auth.auth().signOut()
               self.user = nil
               self.isSignedIn = false
               self.isSignedOut = true
           } catch {
               self.loginOrSignUpError = FirebaseError(message: error.localizedDescription)
               print("Sign Out Error: \(error.localizedDescription)")
           }
       }
}

struct FirebaseError: Identifiable {
    let id = UUID()
    let message: String
}
