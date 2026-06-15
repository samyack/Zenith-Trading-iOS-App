//
//  LoginAndSignupView.swift
//  Zenith Trading
//
//  Created by Samyack on 27/05/26.
//
import SwiftUI
import FirebaseAuth

struct LoginAndSignupView: View {
    var clickedLogin: Bool
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var name: String = ""
    @State var isPasswordVisible = false
    
    
    @StateObject private var viewModel = AuthViewModel()
    
    // Logic for button color & activation
    var isFormValid: Bool {
        if clickedLogin {
            return !email.isEmpty && !password.isEmpty
        } else {
            return !email.isEmpty && !password.isEmpty && (password == confirmPassword)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(clickedLogin ? "Log In" : "Sign Up")
                    .font(.largeTitle.bold())
                    .padding(.bottom, 10)
                // name
                if !clickedLogin {
                    TextField("Name", text: $name)
                        .customFieldStyle()
                }
                
                // Email Field
                TextField("Email", text: $email)
                    .customFieldStyle()
                    .autocapitalization(.none)
                
                // Password Field
                
                HStack {
                    // Toggle between SecureField and TextField based on the state
                    if isPasswordVisible {
                        TextField("Enter Password", text: $password)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    } else {
                        SecureField("Enter Password", text: $password)
                    }
                    
                    // Show/Hide Button
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 4)
                    }
                }
                .customFieldStyle()
                // Show Confirm Password only if signing up
                if !clickedLogin {
                    HStack {
                        // Toggle between SecureField and TextField based on the state
                        if isPasswordVisible {
                            TextField("Confirm Enter Password", text: $confirmPassword)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        } else {
                            SecureField("Confirm Enter Password", text: $confirmPassword)
                        }
                        
                        // Show/Hide Button
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 4)
                        }
                    }
                    .customFieldStyle()
                }
                
                // Dynamic Button
                Button(clickedLogin ? "LOG IN" : "CREATE ACCOUNT") {
                    if clickedLogin {
                        viewModel.signIn(email: email, password: password)
                        
                    } else {
                        viewModel.signUp(email: email, password: password, name: name)
                    }
                }
                .buttonStyle(NeumorphicButtonStyle(
                    bgColor: isFormValid ? .orange : Color(.systemGray4),
                    shadowColor: isFormValid ? Color.orange.opacity(0.7) : Color(.systemGray3)
                ))
                .padding(.top, 10)
                .disabled(!isFormValid)
                
                Spacer()
            }
            .padding(20)
            
            .navigationDestination(isPresented: $viewModel.isSignedIn) {
                HomeView()
            }
            
        }
        .alert(item: $viewModel.loginOrSignUpError) { error in
            Alert(title: Text("Error"),message: Text(error.message), dismissButton: .default(Text("OK")))
        }
    }
        
}

// MARK: - TextField Style
extension View {
    func customFieldStyle() -> some View {
        self
            .padding()
            .background(Color(.systemGray6).opacity(0.5))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.orange.opacity(0.4), lineWidth: 2)
            )
            .padding(.horizontal)
    }
}

#Preview {
    LoginAndSignupView(clickedLogin: true)
}
