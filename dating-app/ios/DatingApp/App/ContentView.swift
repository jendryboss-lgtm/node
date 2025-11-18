//
//  ContentView.swift
//  DatingApp
//
//  Root content view handling authentication state
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView()
                    .transition(.opacity)
            } else {
                AuthenticationView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: authViewModel.isAuthenticated)
        .onAppear {
            authViewModel.checkAuthenticationStatus()
        }
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var matchesViewModel = MatchesViewModel()
    @StateObject private var messagesViewModel = MessagesViewModel()

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            DiscoveryView()
                .tabItem {
                    Image(systemName: "flame.fill")
                    Text("Discover")
                }
                .tag(AppState.Tab.discover)

            MatchesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Matches")
                }
                .tag(AppState.Tab.matches)
                .environmentObject(matchesViewModel)

            MessagesListView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Messages")
                }
                .tag(AppState.Tab.messages)
                .environmentObject(messagesViewModel)

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(AppState.Tab.profile)
        }
        .accentColor(.pink)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(AppState())
}
