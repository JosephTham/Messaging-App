//
//  CreateServerViewModel.swift
//  ConFlow
//
//  Created by Joseph Tham on 7/16/24.
//

import Foundation
import Firebase

class CreateServerViewModel: ObservableObject {
    @Published var serverName: String = ""
    @Published var serverCode: String = ""
    @Published var errorMessage: String?
    @Published var successMessage: String?

    func generateServerCode() -> String {
        return UUID().uuidString.prefix(8).uppercased()
    }

    func createServer() {
        guard !serverName.isEmpty else {
            errorMessage = "Server name cannot be empty"
            return
        }

        let code = generateServerCode()
        let db = Firestore.firestore()
        
        db.collection("groupChats").document(code).setData([
            "name": serverName,
            "members": [:]
        ]) { error in
            if let error = error {
                self.errorMessage = "Failed to create server: \(error.localizedDescription)"
                self.successMessage = nil
            } else {
                self.serverCode = code
                self.successMessage = "Server created successfully! Code: \(code)"
                self.errorMessage = nil
            }
        }
    }
}
