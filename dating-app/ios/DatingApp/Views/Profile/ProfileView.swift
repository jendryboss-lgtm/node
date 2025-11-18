//
//  ProfileView.swift
//  DatingApp
//
//  User profile and settings view
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSettings = false
    @State private var showEditProfile = false
    @State private var showPremium = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile header
                    ProfileHeaderView(
                        user: authViewModel.currentUser,
                        onEditTap: { showEditProfile = true }
                    )

                    // Premium banner
                    if !(authViewModel.currentUser?.isPremium ?? false) {
                        PremiumBannerView {
                            showPremium = true
                        }
                    }

                    // Quick actions
                    VStack(spacing: 12) {
                        ProfileActionRow(
                            icon: "pencil",
                            title: "Edit Profile",
                            subtitle: "Update your photos and info"
                        ) {
                            showEditProfile = true
                        }

                        ProfileActionRow(
                            icon: "slider.horizontal.3",
                            title: "Discovery Settings",
                            subtitle: "Distance, age, and more"
                        ) {
                            showSettings = true
                        }

                        ProfileActionRow(
                            icon: "bell",
                            title: "Notifications",
                            subtitle: "Manage your alerts"
                        ) {
                            // Show notifications settings
                        }

                        ProfileActionRow(
                            icon: "shield",
                            title: "Safety & Privacy",
                            subtitle: "Block list, data settings"
                        ) {
                            // Show safety settings
                        }
                    }
                    .padding(.horizontal)

                    // Account section
                    VStack(spacing: 12) {
                        Text("Account")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        ProfileActionRow(
                            icon: "questionmark.circle",
                            title: "Help & Support",
                            subtitle: nil
                        ) {
                            // Show help
                        }

                        ProfileActionRow(
                            icon: "doc.text",
                            title: "Terms & Privacy",
                            subtitle: nil
                        ) {
                            // Show terms
                        }

                        ProfileActionRow(
                            icon: "rectangle.portrait.and.arrow.right",
                            title: "Log Out",
                            subtitle: nil,
                            isDestructive: true
                        ) {
                            authViewModel.logout()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    // Version info
                    Text("Version 1.0.0")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top)
                }
                .padding(.vertical)
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileView()
            }
            .sheet(isPresented: $showPremium) {
                PremiumView()
            }
        }
    }
}

// MARK: - Profile Header View
struct ProfileHeaderView: View {
    let user: User?
    let onEditTap: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // Profile photo
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 120)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                    )

                Button(action: onEditTap) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.pink)
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }

            // Name and verification
            HStack {
                Text(user?.firstName ?? "Your Name")
                    .font(.title2)
                    .fontWeight(.bold)

                if user?.isVerified ?? false {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.blue)
                }
            }

            // Complete profile prompt
            if true { // Check if profile is incomplete
                Button(action: onEditTap) {
                    HStack {
                        Image(systemName: "exclamationmark.circle")
                        Text("Complete your profile")
                    }
                    .font(.subheadline)
                    .foregroundColor(.orange)
                }
            }
        }
        .padding()
    }
}

// MARK: - Premium Banner View
struct PremiumBannerView: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Upgrade to Premium")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("See who likes you & more")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }

                Spacer()

                Image(systemName: "crown.fill")
                    .font(.title2)
                    .foregroundColor(.yellow)
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [.pink, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

// MARK: - Profile Action Row
struct ProfileActionRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    var isDestructive: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isDestructive ? .red : .pink)
                    .frame(width: 30)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .foregroundColor(isDestructive ? .red : .primary)

                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var distance: Double = 50
    @State private var ageMin: Double = 18
    @State private var ageMax: Double = 35
    @State private var globalMode = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Discovery") {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Maximum Distance")
                            Spacer()
                            Text("\(Int(distance)) km")
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $distance, in: 1...100)
                            .tint(.pink)
                    }

                    VStack(alignment: .leading) {
                        HStack {
                            Text("Age Range")
                            Spacer()
                            Text("\(Int(ageMin)) - \(Int(ageMax))")
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Slider(value: $ageMin, in: 18...99)
                            Slider(value: $ageMax, in: 18...99)
                        }
                        .tint(.pink)
                    }

                    Toggle("Global Mode", isOn: $globalMode)
                        .tint(.pink)
                }

                Section("Show Me") {
                    NavigationLink("Gender Preferences") {
                        Text("Gender preferences")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Edit Profile View
struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var bio = ""
    @State private var occupation = ""
    @State private var company = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Photos") {
                    // Photo grid would go here
                    Text("Add photos")
                        .foregroundColor(.secondary)
                }

                Section("About Me") {
                    TextField("Bio", text: $bio, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Work & Education") {
                    TextField("Job Title", text: $occupation)
                    TextField("Company", text: $company)
                }

                Section("Prompts") {
                    NavigationLink("Add prompts") {
                        Text("Prompts editor")
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Save profile
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Premium View
struct PremiumView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedPlan: PremiumPlan = .premium

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.yellow)

                        Text("Upgrade to Premium")
                            .font(.title)
                            .fontWeight(.bold)

                        Text("Get more matches and exclusive features")
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)

                    // Plan selection
                    VStack(spacing: 16) {
                        ForEach(PremiumPlan.allCases, id: \.self) { plan in
                            PlanCard(
                                plan: plan,
                                isSelected: selectedPlan == plan
                            ) {
                                selectedPlan = plan
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Features
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What you get")
                            .font(.headline)

                        ForEach(selectedPlan.features, id: \.self) { feature in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(feature)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // Subscribe button
                    Button(action: {
                        // Handle subscription
                    }) {
                        Text("Subscribe for \(selectedPlan.monthlyPrice)/month")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.pink, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                    }
                    .padding(.horizontal)

                    // Terms
                    Text("Cancel anytime. Recurring billing.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

// MARK: - Plan Card
struct PlanCard: View {
    let plan: PremiumPlan
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(plan.displayName)
                        .font(.headline)
                    Text(plan.monthlyPrice + "/month")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.pink)
                }
            }
            .padding()
            .background(isSelected ? Color.pink.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.pink : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
