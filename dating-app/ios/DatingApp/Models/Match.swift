//
//  Match.swift
//  DatingApp
//
//  Match and Message data models
//

import Foundation

// MARK: - Match Model
struct Match: Codable, Identifiable {
    let id: String
    let user1Id: String
    let user2Id: String
    let isActive: Bool
    let matchedAt: Date
    let lastMessageAt: Date?
    let profile: DiscoveryProfile?

    enum CodingKeys: String, CodingKey {
        case id
        case user1Id = "user1_id"
        case user2Id = "user2_id"
        case isActive = "is_active"
        case matchedAt = "matched_at"
        case lastMessageAt = "last_message_at"
        case profile
    }
}

// MARK: - Message Model
struct Message: Codable, Identifiable {
    let id: String
    let matchId: String
    let senderId: String
    let receiverId: String
    let content: String
    let type: MessageType
    let mediaUrl: String?
    let isRead: Bool
    let readAt: Date?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case matchId = "match_id"
        case senderId = "sender_id"
        case receiverId = "receiver_id"
        case content
        case type
        case mediaUrl = "media_url"
        case isRead = "is_read"
        case readAt = "read_at"
        case createdAt = "created_at"
    }
}

// MARK: - Message Type
enum MessageType: String, Codable {
    case text
    case image
    case video
    case audio
    case gif
}

// MARK: - Swipe Action
enum SwipeAction: String, Codable {
    case like
    case pass
    case superLike = "super_like"
}

// MARK: - Swipe Response
struct SwipeResponse: Codable {
    let success: Bool
    let isMatch: Bool
    let match: Match?

    enum CodingKeys: String, CodingKey {
        case success
        case isMatch = "is_match"
        case match
    }
}

// MARK: - Conversation
struct Conversation: Identifiable {
    let id: String
    let match: Match
    let lastMessage: Message?
    let unreadCount: Int
    let profile: DiscoveryProfile

    var displayName: String {
        profile.firstName
    }

    var lastMessagePreview: String {
        lastMessage?.content ?? "Say hello! 👋"
    }

    var timeAgo: String {
        guard let date = lastMessage?.createdAt ?? match.matchedAt as Date? else {
            return ""
        }
        return date.timeAgoDisplay()
    }
}

// MARK: - Date Extension
extension Date {
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear], from: self, to: now)

        if let weeks = components.weekOfYear, weeks > 0 {
            return weeks == 1 ? "1w" : "\(weeks)w"
        }
        if let days = components.day, days > 0 {
            return days == 1 ? "1d" : "\(days)d"
        }
        if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1h" : "\(hours)h"
        }
        if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "1m" : "\(minutes)m"
        }
        return "now"
    }
}
