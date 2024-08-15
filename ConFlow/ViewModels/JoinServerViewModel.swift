//
//  JoinServerViewModel.swift
//  ConFlow
//
//  Created by Joseph Tham on 8/9/24.
//

import Foundation
import Firebase

class JoinServerViewModel: ObservableObject {
    @Published var serverCode: String = ""
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var user: User = User(id: "", name: "", email: "", joined: Date().timeIntervalSince1970)
    @Published var previousServers: [Server] = []

    func joinServer(code: String, completion: @escaping (Bool) -> Void) {
        guard !code.isEmpty else {
            errorMessage = "Server code cannot be empty"
            completion(false)
            return
        }

        let db = Firestore.firestore()
        
        db.collection("groupChats").document(code).getDocument { document, error in
            if let error = error {
                self.errorMessage = "Failed to join server: \(error.localizedDescription)"
                self.successMessage = nil
                completion(false)
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data(),
                  let serverName = data["name"] as? String else {
                self.errorMessage = "Invalid server code"
                self.successMessage = nil
                completion(false)
                return
            }

            if let currentUser = Auth.auth().currentUser {
                self.user = User(id: currentUser.uid, name: currentUser.displayName ?? "Unknown", email: currentUser.email ?? "", joined: Date().timeIntervalSince1970)
                
                let userId = currentUser.uid
                let userRef = db.collection("groupChats").document(code)

                userRef.updateData([
                    "members.\(userId)": true
                ]) { error in
                    if let error = error {
                        self.errorMessage = "Failed to join server: \(error.localizedDescription)"
                        self.successMessage = nil
                        completion(false)
                    } else {
                        self.successMessage = "Successfully joined server!"
                        self.errorMessage = nil
                        let server = Server(id: document.documentID, name: serverName, code: code, members: [])
                        self.addToPreviousServers(server: server)
                        completion(true)
                    }
                }
            } else {
                self.errorMessage = "User is not authenticated"
                self.successMessage = nil
                completion(false)
            }
        }
    }
    
    func addToPreviousServers(server: Server) {
        if !previousServers.contains(where: { $0.code == server.code }) {
            previousServers.append(server)
            if let encoded = try? JSONEncoder().encode(previousServers) {
                UserDefaults.standard.set(encoded, forKey: "previousServers")
            }
        }
    }

    func loadPreviousServers() {
        if let data = UserDefaults.standard.data(forKey: "previousServers"),
           let decoded = try? JSONDecoder().decode([Server].self, from: data) {
            previousServers = decoded
        }
    }
}
