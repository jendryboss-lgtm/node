//
//  APIModels.swift
//  DatingApp
//
//  API request and response models
//

import Foundation

// MARK: - API Response Wrapper
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let message: String?
    let data: T?
    let errors: [APIError]?
}

struct APIError: Codable {
    let field: String?
    let message: String
}

// MARK: - Auth Models
struct LoginRequest: Codable {
    let phoneNumber: String
    let code: String?

    enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
        case code
    }
}

struct RegisterRequest: Codable {
    let phoneNumber: String
    let firstName: String
    let birthDate: String
    let gender: String

    enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
        case firstName = "first_name"
        case birthDate = "birth_date"
        case gender
    }
}

struct VerifyRequest: Codable {
    let phoneNumber: String
    let code: String

    enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
        case code
    }
}

struct AuthResponse: Codable {
    let success: Bool
    let token: String?
    let refreshToken: String?
    let user: User?
    let verificationSent: Bool?

    enum CodingKeys: String, CodingKey {
        case success
        case token
        case refreshToken = "refresh_token"
        case user
        case verificationSent = "verification_sent"
    }
}

// MARK: - Discovery Models
struct DiscoveryResponse: Codable {
    let profiles: [DiscoveryProfile]
}

struct SwipeRequest: Codable {
    let swipedId: String
    let action: String

    enum CodingKeys: String, CodingKey {
        case swipedId = "swiped_id"
        case action
    }
}

// MARK: - Matches Models
struct MatchesResponse: Codable {
    let matches: [Match]
}

struct LikesResponse: Codable {
    let likes: [DiscoveryProfile]
    let count: Int
}

// MARK: - Messages Models
struct MessagesResponse: Codable {
    let messages: [Message]
}

struct SendMessageRequest: Codable {
    let content: String
    let type: String
    let mediaUrl: String?

    enum CodingKeys: String, CodingKey {
        case content
        case type
        case mediaUrl = "media_url"
    }
}

// MARK: - Profile Update Models
struct UpdateProfileRequest: Codable {
    var bio: String?
    var occupation: String?
    var company: String?
    var school: String?
    var educationLevel: String?
    var heightCm: Int?
    var relationshipGoal: String?
    var interests: [String]?
    var distancePreferenceKm: Int?
    var minAgePreference: Int?
    var maxAgePreference: Int?
    var genderPreference: [String]?

    enum CodingKeys: String, CodingKey {
        case bio
        case occupation
        case company
        case school
        case educationLevel = "education_level"
        case heightCm = "height_cm"
        case relationshipGoal = "relationship_goal"
        case interests
        case distancePreferenceKm = "distance_preference_km"
        case minAgePreference = "min_age_preference"
        case maxAgePreference = "max_age_preference"
        case genderPreference = "gender_preference"
    }
}

// MARK: - Subscription Models
struct Subscription: Codable {
    let id: String
    let planType: String
    let status: String
    let currentPeriodEnd: Date

    enum CodingKeys: String, CodingKey {
        case id
        case planType = "plan_type"
        case status
        case currentPeriodEnd = "current_period_end"
    }
}

struct CreateSubscriptionRequest: Codable {
    let plan: String
    let paymentMethodId: String

    enum CodingKeys: String, CodingKey {
        case plan
        case paymentMethodId = "payment_method_id"
    }
}

// MARK: - Report Models
struct ReportRequest: Codable {
    let reportedId: String
    let reason: String
    let description: String?

    enum CodingKeys: String, CodingKey {
        case reportedId = "reported_id"
        case reason
        case description
    }
}

// MARK: - Premium Plans
enum PremiumPlan: String, CaseIterable {
    case premium
    case premiumPlus = "premium_plus"

    var displayName: String {
        switch self {
        case .premium: return "Premium"
        case .premiumPlus: return "Premium+"
        }
    }

    var monthlyPrice: String {
        switch self {
        case .premium: return "$19.99"
        case .premiumPlus: return "$29.99"
        }
    }

    var features: [String] {
        switch self {
        case .premium:
            return [
                "Unlimited likes",
                "See who likes you",
                "5 Super Likes per week",
                "1 Boost per month",
                "Rewind last swipe",
                "No ads"
            ]
        case .premiumPlus:
            return [
                "All Premium features",
                "Unlimited Super Likes",
                "2 Boosts per month",
                "Priority profile placement",
                "Message before matching",
                "Video calling"
            ]
        }
    }
}
