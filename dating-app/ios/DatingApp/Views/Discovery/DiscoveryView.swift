//
//  DiscoveryView.swift
//  DatingApp
//
//  Main discovery view with swipeable cards
//

import SwiftUI

struct DiscoveryView: View {
    @StateObject private var viewModel = DiscoveryViewModel()
    @State private var showFilters = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()

                VStack {
                    if viewModel.isLoading && viewModel.profiles.isEmpty {
                        ProgressView("Finding matches...")
                            .padding()
                    } else if viewModel.profiles.isEmpty {
                        EmptyDiscoveryView {
                            Task { await viewModel.fetchProfiles() }
                        }
                    } else {
                        // Card stack
                        CardStackView(viewModel: viewModel)
                    }
                }
            }
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showFilters = true }) {
                        Image(systemName: "slider.horizontal.3")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "bell")
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                FiltersView()
            }
            .fullScreenCover(isPresented: $viewModel.showMatch) {
                if let profile = viewModel.matchedProfile {
                    MatchView(profile: profile) {
                        viewModel.dismissMatch()
                    }
                }
            }
            .task {
                await viewModel.fetchProfiles()
            }
        }
    }
}

// MARK: - Card Stack View
struct CardStackView: View {
    @ObservedObject var viewModel: DiscoveryViewModel

    var body: some View {
        VStack {
            // Cards
            ZStack {
                ForEach(Array(viewModel.profiles.enumerated().reversed()), id: \.element.id) { index, profile in
                    if index >= viewModel.currentIndex && index < viewModel.currentIndex + 3 {
                        ProfileCardView(
                            profile: profile,
                            onSwipe: { action in
                                Task { await viewModel.swipe(action) }
                            }
                        )
                        .offset(y: CGFloat(index - viewModel.currentIndex) * 8)
                        .scaleEffect(1 - CGFloat(index - viewModel.currentIndex) * 0.05)
                        .allowsHitTesting(index == viewModel.currentIndex)
                    }
                }
            }
            .padding()

            // Action buttons
            HStack(spacing: 20) {
                // Pass button
                ActionButton(
                    icon: "xmark",
                    color: .red,
                    size: 60
                ) {
                    Task { await viewModel.pass() }
                }

                // Rewind button (Premium)
                ActionButton(
                    icon: "arrow.uturn.backward",
                    color: .orange,
                    size: 50
                ) {
                    viewModel.rewind()
                }

                // Super Like button
                ActionButton(
                    icon: "star.fill",
                    color: .blue,
                    size: 50
                ) {
                    Task { await viewModel.superLike() }
                }

                // Like button
                ActionButton(
                    icon: "heart.fill",
                    color: .green,
                    size: 60
                ) {
                    Task { await viewModel.like() }
                }
            }
            .padding(.bottom, 20)
        }
    }
}

// MARK: - Profile Card View
struct ProfileCardView: View {
    let profile: DiscoveryProfile
    let onSwipe: (SwipeAction) -> Void

    @State private var offset: CGSize = .zero
    @State private var currentPhotoIndex = 0

    private let swipeThreshold: CGFloat = 100

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Photo
                if let photoUrl = profile.photos[safe: currentPhotoIndex]?.url ?? profile.primaryPhotoUrl {
                    AsyncImage(url: URL(string: photoUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(ProgressView())
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                }

                // Photo indicators
                VStack {
                    HStack(spacing: 4) {
                        ForEach(0..<profile.photos.count, id: \.self) { index in
                            Rectangle()
                                .fill(index == currentPhotoIndex ? Color.white : Color.white.opacity(0.5))
                                .frame(height: 3)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    Spacer()
                }

                // Gradient overlay
                LinearGradient(
                    colors: [.clear, .black.opacity(0.7)],
                    startPoint: .center,
                    endPoint: .bottom
                )

                // Profile info
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(profile.firstName)
                            .font(.title)
                            .fontWeight(.bold)

                        Text("\(profile.age)")
                            .font(.title2)

                        if profile.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.blue)
                        }
                    }

                    if let occupation = profile.occupation {
                        HStack {
                            Image(systemName: "briefcase.fill")
                            Text(occupation)
                        }
                        .font(.subheadline)
                    }

                    HStack {
                        Image(systemName: "location.fill")
                        Text(String(format: "%.1f km away", profile.distanceKm))
                    }
                    .font(.subheadline)

                    if let bio = profile.bio, !bio.isEmpty {
                        Text(bio)
                            .font(.body)
                            .lineLimit(2)
                            .padding(.top, 4)
                    }
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)

                // Swipe indicators
                HStack {
                    // NOPE indicator
                    Text("NOPE")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red, lineWidth: 3)
                        )
                        .rotationEffect(.degrees(-20))
                        .opacity(Double(-offset.width / 100))

                    Spacer()

                    // LIKE indicator
                    Text("LIKE")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.green, lineWidth: 3)
                        )
                        .rotationEffect(.degrees(20))
                        .opacity(Double(offset.width / 100))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            .cornerRadius(20)
            .shadow(radius: 5)
            .offset(offset)
            .rotationEffect(.degrees(Double(offset.width / 20)))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                    }
                    .onEnded { gesture in
                        withAnimation(.spring()) {
                            if offset.width > swipeThreshold {
                                offset = CGSize(width: 500, height: 0)
                                onSwipe(.like)
                            } else if offset.width < -swipeThreshold {
                                offset = CGSize(width: -500, height: 0)
                                onSwipe(.pass)
                            } else if offset.height < -swipeThreshold {
                                offset = CGSize(width: 0, height: -500)
                                onSwipe(.superLike)
                            } else {
                                offset = .zero
                            }
                        }
                    }
            )
            .onTapGesture { location in
                // Tap left/right to change photo
                let width = geometry.size.width
                if location.x < width / 2 {
                    if currentPhotoIndex > 0 {
                        currentPhotoIndex -= 1
                    }
                } else {
                    if currentPhotoIndex < profile.photos.count - 1 {
                        currentPhotoIndex += 1
                    }
                }
            }
        }
        .aspectRatio(0.7, contentMode: .fit)
    }
}

// MARK: - Action Button
struct ActionButton: View {
    let icon: String
    let color: Color
    let size: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size * 0.4))
                .foregroundColor(color)
                .frame(width: size, height: size)
                .background(Color(.systemBackground))
                .clipShape(Circle())
                .shadow(color: color.opacity(0.3), radius: 5)
        }
    }
}

// MARK: - Empty Discovery View
struct EmptyDiscoveryView: View {
    let onRefresh: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.badge.questionmark")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text("No more profiles")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Check back later or expand your preferences")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button(action: onRefresh) {
                Text("Refresh")
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(25)
            }
            .padding(.top)
        }
        .padding()
    }
}

// MARK: - Match View
struct MatchView: View {
    let profile: DiscoveryProfile
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.pink, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                Text("It's a Match!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("You and \(profile.firstName) liked each other")
                    .foregroundColor(.white.opacity(0.9))

                // Profile photo
                if let photoUrl = profile.primaryPhotoUrl {
                    AsyncImage(url: URL(string: photoUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                }

                Spacer()

                VStack(spacing: 16) {
                    Button(action: {
                        // Navigate to chat
                        onDismiss()
                    }) {
                        Text("Send a Message")
                            .font(.headline)
                            .foregroundColor(.pink)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(25)
                    }

                    Button(action: onDismiss) {
                        Text("Keep Swiping")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

// MARK: - Filters View
struct FiltersView: View {
    @Environment(\.dismiss) var dismiss
    @State private var distance: Double = 50
    @State private var ageRange: ClosedRange<Double> = 18...35
    @State private var showMe: [Gender] = [.female]

    var body: some View {
        NavigationStack {
            Form {
                Section("Distance") {
                    VStack {
                        Slider(value: $distance, in: 1...100, step: 1)
                        Text("\(Int(distance)) km")
                            .foregroundColor(.secondary)
                    }
                }

                Section("Age Range") {
                    VStack {
                        Text("\(Int(ageRange.lowerBound)) - \(Int(ageRange.upperBound))")
                        // Would use RangeSlider here
                    }
                }

                Section("Show Me") {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        Button(action: {
                            if showMe.contains(gender) {
                                showMe.removeAll { $0 == gender }
                            } else {
                                showMe.append(gender)
                            }
                        }) {
                            HStack {
                                Text(gender.displayName)
                                Spacer()
                                if showMe.contains(gender) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.pink)
                                }
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Array Extension
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    DiscoveryView()
}
