//
//  ChatView.swift
//  ConFlow
//
//  Created by Joseph Tham on 8/9/24.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @State private var scrollViewProxy: ScrollViewProxy? = nil

    init(serverCode: String, user: User) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(serverCode: serverCode, user: user))
    }

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.messages, id: \.id) { message in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(message.senderName)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\(message.text)")
                                        .padding()
                                        .background(message.senderId == viewModel.user.id ? Color.gray : Color.gray.opacity(0.2))
                                        .foregroundColor(message.senderId == viewModel.user.id ? .white : .black)
                                        .cornerRadius(10)
                                        .padding(.trailing, 50)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 4)
                            .id(message.id)
                        }
                    }
                }
                .padding()
                .onAppear {
                    scrollViewProxy = proxy
                }
            }

            HStack {
                TextField("Enter message", text: $viewModel.newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 30)

                Button(action: {
                    viewModel.sendMessage()
                    scrollToBottom()
                }) {
                    Text("Send")
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("Chat")
        .onAppear {
            viewModel.fetchMessages()
        }
    }

    private func scrollToBottom() {
        DispatchQueue.main.async {
            if let lastMessage = viewModel.messages.last {
                scrollViewProxy?.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}

#Preview {
    ChatView(serverCode: "EXAMPLECODE", user: User(id: "1", name: "John Doe", email: "john@example.com", joined: Date().timeIntervalSince1970))
}
