//
//  AuthViewModel.swift
//  DatingApp
//
//  Authentication view model
//

import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var error: String?
    @Published var currentUser: User?
    @Published var verificationSent = false

    private let api = APIService.shared

    // MARK: - Check Auth Status
    func checkAuthenticationStatus() {
        if let _ = KeychainService.shared.get(key: "authToken") {
            isAuthenticated = true
            Task {
                await fetchCurrentUser()
            }
        }
    }

    // MARK: - Register
    func register(phoneNumber: String, firstName: String, birthDate: Date, gender: Gender) async {
        isLoading = true
        error = nil

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let request = RegisterRequest(
            phoneNumber: phoneNumber,
            firstName: firstName,
            birthDate: dateFormatter.string(from: birthDate),
            gender: gender.rawValue
        )

        do {
            let response: AuthResponse = try await api.request(
                endpoint: "/auth/register",
                method: .post,
                body: request,
                requiresAuth: false
            )

            if response.success {
                verificationSent = response.verificationSent ?? true
            } else {
                error = "Registration failed"
            }
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Send Verification Code
    func sendVerificationCode(phoneNumber: String) async {
        isLoading = true
        error = nil

        let request = LoginRequest(phoneNumber: phoneNumber, code: nil)

        do {
            let response: AuthResponse = try await api.request(
                endpoint: "/auth/login",
                method: .post,
                body: request,
                requiresAuth: false
            )

            verificationSent = response.verificationSent ?? true
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Verify Code
    func verifyCode(phoneNumber: String, code: String) async {
        isLoading = true
        error = nil

        let request = VerifyRequest(phoneNumber: phoneNumber, code: code)

        do {
            let response: AuthResponse = try await api.request(
                endpoint: "/auth/verify",
                method: .post,
                body: request,
                requiresAuth: false
            )

            if response.success, let token = response.token {
                api.setAuthToken(token)

                if let refreshToken = response.refreshToken {
                    KeychainService.shared.save(key: "refreshToken", value: refreshToken)
                }

                currentUser = response.user
                isAuthenticated = true
            } else {
                error = "Verification failed"
            }
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Fetch Current User
    func fetchCurrentUser() async {
        do {
            let response: APIResponse<User> = try await api.request(endpoint: "/users/me")
            currentUser = response.data
        } catch {
            // Token might be invalid
            if case APIError.unauthorized = error {
                logout()
            }
        }
    }

    // MARK: - Logout
    func logout() {
        api.clearAuthToken()
        KeychainService.shared.delete(key: "refreshToken")
        currentUser = nil
        isAuthenticated = false
    }
}
