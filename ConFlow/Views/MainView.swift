//
//  ContentView.swift
//  ConFlow
//
//  Created by Joseph Tham on 7/14/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            TabView {
                JoinServerView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                CreateServerView()
                    .tabItem {
                        Label("Create", systemImage: "hammer")
                    }
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
            }
        } else {
            LoginView()
        }
    }
}

#Preview {
    MainView()
}
