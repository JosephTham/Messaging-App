//
//  RegisterView.swift
//  ConFlow
//
//  Created by Joseph Tham on 7/14/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    var body: some View {
        VStack {
            HeaderView(title: "Registration", background: .orange)
                .offset(y: -40)
            
            Form {
                TextField("Full name", text : $viewModel.name)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()
                TextField("Email", text : $viewModel.email)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .autocorrectionDisabled()
                TextField("Password", text : $viewModel.password)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                MButton(title: "Create Account", background: .green) {
                    viewModel.register()
                }
            }
            .offset(y: -90)
            
            Spacer()
        }
    }
}

#Preview {
    RegisterView()
}
