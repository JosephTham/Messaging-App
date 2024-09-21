//
//  ChatView.swift
//  ConFlow
//
//  Created by Joseph Tham on 8/9/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @State private var scrollViewProxy: ScrollViewProxy? = nil
    @State private var user: User? = nil  // State to hold the fetched user

    init(serverCode: String) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(serverCode: serverCode))
    }

    var body: some View {
        VStack {
            if let user = user {
                // Chat UI only shows if the user is fetched successfully
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
                                            .background(message.senderId == user.id ? Color.gray : Color.gray)
                                            .foregroundColor(message.senderId == user.id ? .white : .white) // text color
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
            } else {
                // Loading view while user is being fetched
                Text("Loading user data...")
            }
        }
        .navigationTitle("Chat")
        .onAppear {
            fetchCurrentUser()
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

    // Function to fetch the current user from Firebase Auth & Firestore
    private func fetchCurrentUser() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No authenticated user found.")
            return
        }

        let userId = currentUser.uid
        let db = Firestore.firestore()

        db.collection("users").document(userId).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.user = User(
                    id: document.documentID,
                    name: data?["name"] as? String ?? "Unknown",
                    email: data?["email"] as? String ?? "",
                    joined: data?["joined"] as? TimeInterval ?? 0
                )
                // Pass user to ViewModel once it's fetched
                viewModel.setUser(user: self.user!)
            } else {
                print("User does not exist")
            }
        }
    }
}

#Preview {
    ChatView(serverCode: "EXAMPLECODE")
}
