//
//  ChatViewModel.swift
//  ConFlow
//
//  Created by Joseph Tham on 8/9/24.
//

import Foundation
import FirebaseFirestore
import Combine
import FirebaseAuth

struct Message: Codable, Identifiable {
    let id: String
    let senderId: String
    let senderName: String
    let text: String
    let timestamp: TimeInterval
}

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var newMessage: String = ""
    let serverCode: String
    var user: User?  // Change to optional User, since it's set later
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?

    init(serverCode: String) {
        self.serverCode = serverCode
    }

    deinit {
        listenerRegistration?.remove()
    }

    func setUser(user: User) {
        self.user = user
    }

    func fetchMessages() {
        listenerRegistration = db.collection("groupChats")
            .document(serverCode)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error)")
                    return
                }

                self?.messages = snapshot?.documents.compactMap { document -> Message? in
                    try? document.data(as: Message.self)
                } ?? []
            }
    }

    func sendMessage() {
        guard let user = user, !newMessage.isEmpty else { return }

        let message = Message(
            id: UUID().uuidString,
            senderId: user.id,
            senderName: user.name,
            text: newMessage,
            timestamp: Date().timeIntervalSince1970
        )

        do {
            try db.collection("groupChats")
                .document(serverCode)
                .collection("messages")
                .document(message.id)
                .setData(from: message)
            newMessage = ""
        } catch {
            print("Error sending message: \(error)")
        }
    }
}
