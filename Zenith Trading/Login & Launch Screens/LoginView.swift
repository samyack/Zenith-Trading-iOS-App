//
//  LoginView.swift
//  Zenith Trading
//
//  Created by Samyack on 27/05/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = AuthViewModel()
    
    @State private var showAuthScreen = false
    @State private var isLoginMode = true
    
    let lightGrayShadow = Color(red: 220/255, green: 220/255, blue: 220/255)
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                // MARK: - GIFs
                AnimatedImage(name: "Welcome.gif")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 60)
                
                AnimatedImage(name: "bitcoin.gif")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                // MARK: - Buttons
                VStack(spacing: 16) {
                    
                    Button {
                        isLoginMode = true
                        showAuthScreen = true
                    } label: {
                        Text("Log In")
                    }
                    .buttonStyle(NeumorphicButtonStyle(bgColor: .gray, shadowColor: lightGrayShadow))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lightGrayShadow, lineWidth: 2)
                    )
                    
                    
                    Button {
                        isLoginMode = false
                        showAuthScreen = true
                    } label: {
                        Text("Sign Up")
                    }
                    .buttonStyle(NeumorphicButtonStyle(bgColor: .gray, shadowColor: .orange))
                    
                }
                .padding(.bottom, 20)
                
                Spacer()
            }
            .padding(20)
            
            // MARK: - Navigation
            
            // Login / Signup Screen
            .navigationDestination(isPresented: $showAuthScreen) {
                LoginAndSignupView(clickedLogin: isLoginMode)
            }
            
            // Home Screen after login
            .navigationDestination(isPresented: $viewModel.isSignedIn) {
                HomeView()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: - Button Style
struct NeumorphicButtonStyle: ButtonStyle {
    var bgColor: Color
    var shadowColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .foregroundColor(bgColor == .white ? .gray : .white)
            .padding()
            .frame(maxWidth: .infinity)
        // The "Depth" Layer
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(shadowColor)
                    .offset(y: configuration.isPressed ? 0 : 6)
            )
        // The "Face" Layer
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(bgColor)
            )
            .offset(y: configuration.isPressed ? 6 : 0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}


#Preview {
    LoginView()
}
