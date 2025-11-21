//
//  DatingAppApp.swift
//  DatingApp
//
//  Main entry point for the Dating App
//

import SwiftUI

@main
struct DatingAppApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(appState)
                .preferredColorScheme(appState.isDarkMode ? .dark : .light)
        }
    }
}

// MARK: - App State
class AppState: ObservableObject {
    @Published var isDarkMode: Bool = false
    @Published var showOnboarding: Bool = true
    @Published var selectedTab: Tab = .discover

    enum Tab: Int {
        case discover = 0
        case matches = 1
        case messages = 2
        case profile = 3
    }
}
