//
//  DiscoveryViewModel.swift
//  DatingApp
//
//  Discovery and swiping view model
//

import Foundation
import SwiftUI

@MainActor
class DiscoveryViewModel: ObservableObject {
    @Published var profiles: [DiscoveryProfile] = []
    @Published var currentIndex = 0
    @Published var isLoading = false
    @Published var error: String?
    @Published var showMatch = false
    @Published var matchedProfile: DiscoveryProfile?

    private let api = APIService.shared

    var currentProfile: DiscoveryProfile? {
        guard currentIndex < profiles.count else { return nil }
        return profiles[currentIndex]
    }

    var hasMoreProfiles: Bool {
        currentIndex < profiles.count
    }

    // MARK: - Fetch Profiles
    func fetchProfiles() async {
        guard !isLoading else { return }

        isLoading = true
        error = nil

        do {
            let response: DiscoveryResponse = try await api.request(endpoint: "/discovery")
            profiles = response.profiles
            currentIndex = 0
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Swipe Actions
    func swipe(_ action: SwipeAction) async {
        guard let profile = currentProfile else { return }

        let request = SwipeRequest(swipedId: profile.id, action: action.rawValue)

        do {
            let response: SwipeResponse = try await api.request(
                endpoint: "/swipes",
                method: .post,
                body: request
            )

            // Move to next profile
            withAnimation(.spring()) {
                currentIndex += 1
            }

            // Check for match
            if response.isMatch {
                matchedProfile = profile
                showMatch = true

                // Haptic feedback
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }

            // Load more profiles if running low
            if profiles.count - currentIndex < 3 {
                await loadMoreProfiles()
            }
        } catch {
            self.error = error.localizedDescription
        }
    }

    func like() async {
        await swipe(.like)
    }

    func pass() async {
        await swipe(.pass)
    }

    func superLike() async {
        await swipe(.superLike)
    }

    // MARK: - Load More
    private func loadMoreProfiles() async {
        do {
            let response: DiscoveryResponse = try await api.request(endpoint: "/discovery")
            profiles.append(contentsOf: response.profiles)
        } catch {
            // Silently fail for background loading
        }
    }

    // MARK: - Rewind (Premium)
    func rewind() {
        guard currentIndex > 0 else { return }
        withAnimation(.spring()) {
            currentIndex -= 1
        }
    }

    // MARK: - Dismiss Match
    func dismissMatch() {
        showMatch = false
        matchedProfile = nil
    }
}
