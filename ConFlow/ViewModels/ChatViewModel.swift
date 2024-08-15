//
//  ChatViewModel.swift
//  ConFlow
//
//  Created by Joseph Tham on 8/9/24.
//

import Foundation
import FirebaseFirestore
import Combine

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
    let user: User
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?

    init(serverCode: String, user: User) {
        self.serverCode = serverCode
        self.user = user
    }

    deinit {
        listenerRegistration?.remove()
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
        guard !newMessage.isEmpty else { return }

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

