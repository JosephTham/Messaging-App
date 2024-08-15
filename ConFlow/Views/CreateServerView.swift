//
//  CreateServerView.swift
//  ConFlow
//
//  Created by Joseph Tham on 7/16/24.
//

import SwiftUI

struct CreateServerView: View {
    @StateObject private var viewModel = CreateServerViewModel()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter Server Name", text: $viewModel.serverName)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .padding()

                Button(action: {
                    viewModel.createServer()
                }) {
                    Text("Create")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .frame(height: 50)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()

                if let successMessage = viewModel.successMessage {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .padding()
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer()
            }
            .navigationTitle("Create Server")
            .offset(y: 150)
            .padding()
        }
    }
}

#Preview {
    CreateServerView()
}
