//
//  User.swift
//  DatingApp
//
//  User and Profile data models
//

import Foundation

// MARK: - User Model
struct User: Codable, Identifiable {
    let id: String
    let phoneNumber: String?
    let email: String?
    let firstName: String
    let birthDate: Date
    let age: Int
    let gender: Gender
    let status: UserStatus
    let isVerified: Bool
    let isPremium: Bool
    let premiumExpiresAt: Date?
    let lastActiveAt: Date?
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case phoneNumber = "phone_number"
        case email
        case firstName = "first_name"
        case birthDate = "birth_date"
        case age
        case gender
        case status
        case isVerified = "is_verified"
        case isPremium = "is_premium"
        case premiumExpiresAt = "premium_expires_at"
        case lastActiveAt = "last_active_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Gender Enum
enum Gender: String, Codable, CaseIterable {
    case male
    case female
    case nonBinary = "non_binary"
    case other

    var displayName: String {
        switch self {
        case .male: return "Man"
        case .female: return "Woman"
        case .nonBinary: return "Non-binary"
        case .other: return "Other"
        }
    }
}

// MARK: - User Status
enum UserStatus: String, Codable {
    case active
    case inactive
    case banned
    case deleted
}

// MARK: - User Profile
struct UserProfile: Codable, Identifiable {
    let id: String
    let userId: String
    var bio: String?
    var occupation: String?
    var company: String?
    var school: String?
    var educationLevel: EducationLevel?
    var heightCm: Int?
    var relationshipGoal: RelationshipGoal
    var interests: [String]?
    var city: String?
    var state: String?
    var country: String?
    var distancePreferenceKm: Int
    var minAgePreference: Int
    var maxAgePreference: Int
    var genderPreference: [Gender]?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case bio
        case occupation
        case company
        case school
        case educationLevel = "education_level"
        case heightCm = "height_cm"
        case relationshipGoal = "relationship_goal"
        case interests
        case city
        case state
        case country
        case distancePreferenceKm = "distance_preference_km"
        case minAgePreference = "min_age_preference"
        case maxAgePreference = "max_age_preference"
        case genderPreference = "gender_preference"
    }
}

// MARK: - Education Level
enum EducationLevel: String, Codable, CaseIterable {
    case highSchool = "high_school"
    case someCollege = "some_college"
    case bachelors
    case masters
    case phd

    var displayName: String {
        switch self {
        case .highSchool: return "High School"
        case .someCollege: return "Some College"
        case .bachelors: return "Bachelor's Degree"
        case .masters: return "Master's Degree"
        case .phd: return "PhD"
        }
    }
}

// MARK: - Relationship Goal
enum RelationshipGoal: String, Codable, CaseIterable {
    case casual
    case serious
    case unsure
    case friendship

    var displayName: String {
        switch self {
        case .casual: return "Something Casual"
        case .serious: return "Long-term Relationship"
        case .unsure: return "Still Figuring It Out"
        case .friendship: return "New Friends"
        }
    }

    var emoji: String {
        switch self {
        case .casual: return "🎉"
        case .serious: return "💍"
        case .unsure: return "🤔"
        case .friendship: return "👋"
        }
    }
}

// MARK: - User Photo
struct UserPhoto: Codable, Identifiable {
    let id: String
    let userId: String
    let url: String
    let thumbnailUrl: String?
    let position: Int
    let isPrimary: Bool
    let qualityScore: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case url
        case thumbnailUrl = "thumbnail_url"
        case position
        case isPrimary = "is_primary"
        case qualityScore = "quality_score"
    }
}

// MARK: - User Prompt
struct UserPrompt: Codable, Identifiable {
    let id: String
    let userId: String
    let promptText: String
    let answer: String
    let position: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case promptText = "prompt_text"
        case answer
        case position
    }
}

// MARK: - Discovery Profile
struct DiscoveryProfile: Codable, Identifiable {
    let id: String
    let firstName: String
    let age: Int
    let photos: [UserPhoto]
    let bio: String?
    let occupation: String?
    let school: String?
    let distanceKm: Double
    let compatibilityScore: Int?
    let prompts: [UserPrompt]
    let relationshipGoal: RelationshipGoal?
    let interests: [String]?
    let heightCm: Int?
    let isVerified: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case age
        case photos
        case bio
        case occupation
        case school
        case distanceKm = "distance_km"
        case compatibilityScore = "compatibility_score"
        case prompts
        case relationshipGoal = "relationship_goal"
        case interests
        case heightCm = "height_cm"
        case isVerified = "is_verified"
    }

    var primaryPhotoUrl: String? {
        photos.first(where: { $0.isPrimary })?.url ?? photos.first?.url
    }
}
