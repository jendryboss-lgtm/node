//
//  AuthenticationView.swift
//  DatingApp
//
//  Main authentication flow view
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var currentStep: AuthStep = .welcome

    enum AuthStep {
        case welcome
        case phoneEntry
        case verification
        case registration
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.pink.opacity(0.8), Color.purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack {
                    switch currentStep {
                    case .welcome:
                        WelcomeView(onContinue: { currentStep = .phoneEntry })

                    case .phoneEntry:
                        PhoneEntryView(
                            onContinue: { currentStep = .verification },
                            onRegister: { currentStep = .registration }
                        )

                    case .verification:
                        VerificationView(
                            onBack: { currentStep = .phoneEntry }
                        )

                    case .registration:
                        RegistrationView(
                            onComplete: { currentStep = .verification },
                            onBack: { currentStep = .phoneEntry }
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Welcome View
struct WelcomeView: View {
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Logo
            VStack(spacing: 16) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .pink],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Text("Dating App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Find your perfect match")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()

            // Features
            VStack(alignment: .leading, spacing: 16) {
                FeatureRow(icon: "heart.fill", text: "Swipe to match")
                FeatureRow(icon: "message.fill", text: "Chat instantly")
                FeatureRow(icon: "shield.fill", text: "Safe & secure")
            }
            .padding(.horizontal, 40)

            Spacer()

            // Continue button
            Button(action: onContinue) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.pink)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 30)

            Text(text)
                .font(.body)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Phone Entry View
struct PhoneEntryView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var phoneNumber = ""
    let onContinue: () -> Void
    let onRegister: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Text("Enter your phone number")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text("We'll send you a verification code")
                .foregroundColor(.white.opacity(0.8))

            // Phone input
            HStack {
                Text("+1")
                    .foregroundColor(.white)
                    .padding(.leading)

                TextField("Phone number", text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Color.white.opacity(0.2))
            .cornerRadius(12)
            .padding(.horizontal, 40)

            if let error = authViewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Spacer()

            VStack(spacing: 16) {
                // Continue button
                Button(action: {
                    Task {
                        await authViewModel.sendVerificationCode(phoneNumber: "+1\(phoneNumber)")
                        if authViewModel.verificationSent {
                            onContinue()
                        }
                    }
                }) {
                    if authViewModel.isLoading {
                        ProgressView()
                            .tint(.pink)
                    } else {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.pink)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(25)
                .disabled(phoneNumber.count < 10 || authViewModel.isLoading)
                .opacity(phoneNumber.count < 10 ? 0.6 : 1)

                // Register link
                Button(action: onRegister) {
                    Text("New here? Create account")
                        .foregroundColor(.white)
                        .underline()
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Verification View
struct VerificationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var code = ""
    @State private var phoneNumber = "" // Would come from previous screen
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Button(action: onBack) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            Spacer()

            Text("Enter verification code")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text("We sent a 6-digit code to your phone")
                .foregroundColor(.white.opacity(0.8))

            // Code input
            TextField("000000", text: $code)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal, 60)

            if let error = authViewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Spacer()

            // Verify button
            Button(action: {
                Task {
                    await authViewModel.verifyCode(phoneNumber: phoneNumber, code: code)
                }
            }) {
                if authViewModel.isLoading {
                    ProgressView()
                        .tint(.pink)
                } else {
                    Text("Verify")
                        .font(.headline)
                        .foregroundColor(.pink)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(25)
            .disabled(code.count < 6 || authViewModel.isLoading)
            .opacity(code.count < 6 ? 0.6 : 1)
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Registration View
struct RegistrationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var phoneNumber = ""
    @State private var firstName = ""
    @State private var birthDate = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    @State private var selectedGender: Gender = .male

    let onComplete: () -> Void
    let onBack: () -> Void

    var isValid: Bool {
        phoneNumber.count >= 10 && firstName.count >= 2 && age >= 18
    }

    var age: Int {
        Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Button(action: onBack) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                Text("Create your account")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.top, 20)

                VStack(spacing: 16) {
                    // Phone
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phone Number")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.caption)

                        HStack {
                            Text("+1")
                                .foregroundColor(.white)
                            TextField("", text: $phoneNumber)
                                .keyboardType(.phonePad)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                    }

                    // Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("First Name")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.caption)

                        TextField("", text: $firstName)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                    }

                    // Birthday
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Birthday")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.caption)

                        DatePicker("", selection: $birthDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .colorScheme(.dark)
                    }

                    // Gender
                    VStack(alignment: .leading, spacing: 8) {
                        Text("I am a")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.caption)

                        HStack(spacing: 12) {
                            ForEach(Gender.allCases, id: \.self) { gender in
                                Button(action: { selectedGender = gender }) {
                                    Text(gender.displayName)
                                        .font(.subheadline)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(selectedGender == gender ? Color.white : Color.white.opacity(0.2))
                                        .foregroundColor(selectedGender == gender ? .pink : .white)
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 40)

                if let error = authViewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                // Register button
                Button(action: {
                    Task {
                        await authViewModel.register(
                            phoneNumber: "+1\(phoneNumber)",
                            firstName: firstName,
                            birthDate: birthDate,
                            gender: selectedGender
                        )
                        if authViewModel.verificationSent {
                            onComplete()
                        }
                    }
                }) {
                    if authViewModel.isLoading {
                        ProgressView()
                            .tint(.pink)
                    } else {
                        Text("Create Account")
                            .font(.headline)
                            .foregroundColor(.pink)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(25)
                .disabled(!isValid || authViewModel.isLoading)
                .opacity(isValid ? 1 : 0.6)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthViewModel())
}
