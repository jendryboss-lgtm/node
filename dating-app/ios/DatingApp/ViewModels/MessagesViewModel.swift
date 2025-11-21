//
//  MessagesViewModel.swift
//  DatingApp
//
//  Messages and chat view model
//

import Foundation

@MainActor
class MessagesViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isLoading = false
    @Published var isSending = false
    @Published var error: String?

    private let api = APIService.shared
    private var currentMatchId: String?

    // MARK: - Fetch Messages
    func fetchMessages(for matchId: String) async {
        currentMatchId = matchId
        isLoading = true
        error = nil

        do {
            let response: MessagesResponse = try await api.request(
                endpoint: "/matches/\(matchId)/messages"
            )
            messages = response.messages.sorted { $0.createdAt < $1.createdAt }
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Send Message
    func sendMessage(_ content: String, type: MessageType = .text) async {
        guard let matchId = currentMatchId, !content.isEmpty else { return }

        isSending = true

        let request = SendMessageRequest(
            content: content,
            type: type.rawValue,
            mediaUrl: nil
        )

        do {
            let message: Message = try await api.request(
                endpoint: "/matches/\(matchId)/messages",
                method: .post,
                body: request
            )

            messages.append(message)

            // Haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        } catch {
            self.error = error.localizedDescription
        }

        isSending = false
    }

    // MARK: - Mark as Read
    func markAsRead(_ messageId: String) async {
        guard let matchId = currentMatchId else { return }

        do {
            let _: APIResponse<Bool> = try await api.request(
                endpoint: "/matches/\(matchId)/messages/\(messageId)/read",
                method: .put
            )

            // Update local message
            if let index = messages.firstIndex(where: { $0.id == messageId }) {
                // Would need to create a new message with isRead = true
            }
        } catch {
            // Silently fail for read receipts
        }
    }

    // MARK: - Clear Messages
    func clearMessages() {
        messages = []
        currentMatchId = nil
    }
}
