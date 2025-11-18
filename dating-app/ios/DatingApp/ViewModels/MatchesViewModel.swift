//
//  MatchesViewModel.swift
//  DatingApp
//
//  Matches view model
//

import Foundation

@MainActor
class MatchesViewModel: ObservableObject {
    @Published var matches: [Match] = []
    @Published var newMatches: [Match] = []
    @Published var conversations: [Conversation] = []
    @Published var isLoading = false
    @Published var error: String?

    private let api = APIService.shared

    // MARK: - Fetch Matches
    func fetchMatches() async {
        isLoading = true
        error = nil

        do {
            let response: MatchesResponse = try await api.request(endpoint: "/matches")
            matches = response.matches

            // Separate new matches (no messages yet)
            newMatches = matches.filter { $0.lastMessageAt == nil }

            // Create conversations from matches with messages
            conversations = matches
                .filter { $0.lastMessageAt != nil }
                .compactMap { match -> Conversation? in
                    guard let profile = match.profile else { return nil }
                    return Conversation(
                        id: match.id,
                        match: match,
                        lastMessage: nil, // Would need to fetch
                        unreadCount: 0,
                        profile: profile
                    )
                }
                .sorted { ($0.match.lastMessageAt ?? Date.distantPast) > ($1.match.lastMessageAt ?? Date.distantPast) }
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Unmatch
    func unmatch(_ matchId: String) async {
        do {
            let _: APIResponse<Bool> = try await api.request(
                endpoint: "/matches/\(matchId)",
                method: .delete
            )

            // Remove from local arrays
            matches.removeAll { $0.id == matchId }
            newMatches.removeAll { $0.id == matchId }
            conversations.removeAll { $0.id == matchId }
        } catch {
            self.error = error.localizedDescription
        }
    }
}
