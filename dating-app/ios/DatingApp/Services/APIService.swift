//
//  APIService.swift
//  DatingApp
//
//  Main API service for network requests
//

import Foundation

// MARK: - API Service
class APIService {
    static let shared = APIService()

    private let baseURL: String
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    private init() {
        // Configure base URL from environment or use default
        self.baseURL = ProcessInfo.processInfo.environment["API_BASE_URL"] ?? "http://localhost:3000/api/v1"

        // Configure session
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)

        // Configure decoder
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601

        // Configure encoder
        self.encoder = JSONEncoder()
        self.encoder.dateEncodingStrategy = .iso8601
    }

    // MARK: - Token Management
    private var authToken: String? {
        get { KeychainService.shared.get(key: "authToken") }
        set {
            if let token = newValue {
                KeychainService.shared.save(key: "authToken", value: token)
            } else {
                KeychainService.shared.delete(key: "authToken")
            }
        }
    }

    func setAuthToken(_ token: String) {
        authToken = token
    }

    func clearAuthToken() {
        authToken = nil
    }

    // MARK: - Generic Request Method
    func request<T: Codable>(
        endpoint: String,
        method: HTTPMethod = .get,
        body: Encodable? = nil,
        requiresAuth: Bool = true
    ) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add auth token if required
        if requiresAuth, let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Add body if present
        if let body = body {
            request.httpBody = try encoder.encode(body)
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        // Handle HTTP errors
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            clearAuthToken()
            throw APIError.unauthorized
        case 404:
            throw APIError.notFound
        case 400...499:
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                throw APIError.serverError(errorResponse.message)
            }
            throw APIError.badRequest
        case 500...599:
            throw APIError.serverError("Server error")
        default:
            throw APIError.unknown
        }

        return try decoder.decode(T.self, from: data)
    }

    // MARK: - Multipart Upload
    func uploadImage(
        endpoint: String,
        imageData: Data,
        filename: String
    ) async throws -> UserPhoto {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }

        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.uploadFailed
        }

        return try decoder.decode(UserPhoto.self, from: data)
    }
}

// MARK: - HTTP Methods
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

// MARK: - API Errors
enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case unauthorized
    case notFound
    case badRequest
    case serverError(String)
    case uploadFailed
    case decodingError
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .unauthorized:
            return "Please log in again"
        case .notFound:
            return "Resource not found"
        case .badRequest:
            return "Invalid request"
        case .serverError(let message):
            return message
        case .uploadFailed:
            return "Failed to upload file"
        case .decodingError:
            return "Failed to process response"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

// MARK: - Error Response
struct ErrorResponse: Codable {
    let success: Bool
    let message: String
}
