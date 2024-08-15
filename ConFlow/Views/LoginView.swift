//
//  LoginView.swift
//  ConFlow
//
//  Created by Joseph Tham on 7/14/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @State private var showPassword = false

    var body: some View {
        NavigationView {
            VStack {
                HeaderView(title: "ConFlow", background: .blue)
        
                Form {
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                    }
                        
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.none)
                    
                    HStack {
                        if showPassword {
                            TextField("Password", text: $viewModel.password)
                                .textFieldStyle(DefaultTextFieldStyle())
                        } else {
                            SecureField("Password", text: $viewModel.password)
                                .textFieldStyle(DefaultTextFieldStyle())
                        }
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }

                    MButton(title: "Log in", background: .blue) {
                        viewModel.login()
                    }
                }
                .offset(y: -50)
                
                VStack {
                    Text("Don't have an account?")
                    
                    NavigationLink("Sign up", destination: RegisterView())
                }
                .padding(.bottom, 50)
                
                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
}
