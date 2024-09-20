//
//  CreateServerView.swift
//  ConFlow
//
//  Created by Joseph Tham on 7/16/24.
//

import SwiftUI
import UIKit // Import UIKit to use UIPasteboard

struct CreateServerView: View {
    @StateObject private var viewModel = CreateServerViewModel()
    @State private var showCopyAlert = false

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

                    Button(action: {
                        copyToClipboard(viewModel.serverCode)
                        showCopyAlert = true
                    }) {
                        Text("Copy Code")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200)
                            .frame(height: 50)
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .alert(isPresented: $showCopyAlert) {
                        Alert(title: Text("Copied!"), message: Text("Server code copied to clipboard."), dismissButton: .default(Text("OK")))
                    }
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

    // Function to copy server code to clipboard
    private func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
    }
}

#Preview {
    CreateServerView()
}
