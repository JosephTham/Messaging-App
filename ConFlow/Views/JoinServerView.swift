//
//  JoinServerView.swift
//  ConFlow
//
//  Created by Joseph Tham on 7/17/24.
//

import SwiftUI

struct JoinServerView: View {
    @StateObject private var viewModel = JoinServerViewModel()
    @State private var navigateToChat = false
    @State private var selectedServer: Server?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    TextField("Enter Server Code", text: $viewModel.serverCode)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .padding()

                    Button(action: {
                        viewModel.joinServer(code: viewModel.serverCode) { success in
                            if success {
                                selectedServer = viewModel.previousServers.first { $0.code == viewModel.serverCode }
                                navigateToChat = true
                            }
                        }
                    }) {
                        Text("Join")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200, height: 50)
                            .background(Color.green)
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

                    Text("Previously Joined Servers")
                        .font(.headline)
                        .padding(.top, 20)
                    
                    ForEach(viewModel.previousServers, id: \.code) { server in
                        Button(action: {
                            viewModel.joinServer(code: server.code) { success in
                                if success {
                                    selectedServer = server
                                    navigateToChat = true
                                }
                            }
                        }) {
                            Text("Join \(server.name)")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.vertical, 5)
                    }

                    Spacer()
                }
                .navigationTitle("Join Server")
                .offset(y: 50)
                .padding()
            }
            .navigationDestination(isPresented: $navigateToChat) {
                if let server = selectedServer {
                    ChatView(serverCode: server.code)
                    // initially user: viewModel.user
                }
            }
            .onAppear {
                viewModel.loadPreviousServers()
            }
        }
    }
}

#Preview {
    JoinServerView()
}
