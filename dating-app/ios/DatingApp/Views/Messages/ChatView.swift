//
//  ChatView.swift
//  DatingApp
//
//  Chat view for messaging between matches
//

import SwiftUI

struct ChatView: View {
    let match: Match
    let profile: DiscoveryProfile

    @StateObject private var viewModel = MessagesViewModel()
    @State private var messageText = ""
    @State private var showProfileDetail = false
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Messages list
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        // Date header
                        Text(match.matchedAt.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top)

                        // Matched message
                        Text("You matched with \(profile.firstName)!")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 8)

                        // Messages
                        ForEach(viewModel.messages) { message in
                            MessageBubble(
                                message: message,
                                isFromCurrentUser: message.senderId != profile.id
                            )
                            .id(message.id)
                        }
                    }
                    .padding(.horizontal)
                }
                .onChange(of: viewModel.messages.count) { _, _ in
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }

            // Input bar
            MessageInputBar(
                text: $messageText,
                isFocused: $isTextFieldFocused,
                isSending: viewModel.isSending
            ) {
                Task {
                    await viewModel.sendMessage(messageText)
                    messageText = ""
                }
            }
        }
        .navigationTitle(profile.firstName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showProfileDetail = true }) {
                    if let photoUrl = profile.primaryPhotoUrl {
                        AsyncImage(url: URL(string: photoUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                    }
                }
            }
        }
        .sheet(isPresented: $showProfileDetail) {
            ProfileDetailView(profile: profile)
        }
        .task {
            await viewModel.fetchMessages(for: match.id)
        }
        .onDisappear {
            viewModel.clearMessages()
        }
    }
}

// MARK: - Message Bubble
struct MessageBubble: View {
    let message: Message
    let isFromCurrentUser: Bool

    var body: some View {
        HStack {
            if isFromCurrentUser { Spacer() }

            VStack(alignment: isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(isFromCurrentUser ? Color.pink : Color(.systemGray5))
                    .foregroundColor(isFromCurrentUser ? .white : .primary)
                    .cornerRadius(20)

                Text(message.createdAt.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            if !isFromCurrentUser { Spacer() }
        }
    }
}

// MARK: - Message Input Bar
struct MessageInputBar: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    let isSending: Bool
    let onSend: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Camera/media button
            Button(action: {}) {
                Image(systemName: "camera.fill")
                    .foregroundColor(.pink)
            }

            // Text field
            TextField("Type a message...", text: $text)
                .textFieldStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .focused(isFocused)

            // Send button
            Button(action: onSend) {
                if isSending {
                    ProgressView()
                        .frame(width: 32, height: 32)
                } else {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(text.isEmpty ? .gray : .pink)
                }
            }
            .disabled(text.isEmpty || isSending)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.systemGray4)),
            alignment: .top
        )
    }
}

// MARK: - Profile Detail View
struct ProfileDetailView: View {
    let profile: DiscoveryProfile
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Photos
                    TabView {
                        ForEach(profile.photos) { photo in
                            AsyncImage(url: URL(string: photo.url)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                        }
                    }
                    .tabViewStyle(.page)
                    .frame(height: 400)

                    VStack(alignment: .leading, spacing: 16) {
                        // Name and age
                        HStack {
                            Text("\(profile.firstName), \(profile.age)")
                                .font(.title)
                                .fontWeight(.bold)

                            if profile.isVerified {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.blue)
                            }
                        }

                        // Info
                        if let occupation = profile.occupation {
                            Label(occupation, systemImage: "briefcase.fill")
                        }

                        if let school = profile.school {
                            Label(school, systemImage: "graduationcap.fill")
                        }

                        Label(String(format: "%.1f km away", profile.distanceKm), systemImage: "location.fill")

                        if let goal = profile.relationshipGoal {
                            Label("\(goal.emoji) \(goal.displayName)", systemImage: "heart.fill")
                        }

                        // Bio
                        if let bio = profile.bio {
                            Text(bio)
                                .padding(.top)
                        }

                        // Prompts
                        ForEach(profile.prompts) { prompt in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(prompt.promptText)
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                Text(prompt.answer)
                                    .font(.body)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }

                        // Interests
                        if let interests = profile.interests, !interests.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Interests")
                                    .font(.headline)

                                FlowLayout(spacing: 8) {
                                    ForEach(interests, id: \.self) { interest in
                                        Text(interest)
                                            .font(.caption)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.pink.opacity(0.1))
                                            .foregroundColor(.pink)
                                            .cornerRadius(16)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(profile.firstName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Flow Layout
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                      y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: y + rowHeight)
        }
    }
}

// MARK: - Messages List View (for tab)
struct MessagesListView: View {
    @EnvironmentObject var viewModel: MessagesViewModel

    var body: some View {
        NavigationStack {
            Text("Messages")
                .navigationTitle("Messages")
        }
    }
}

#Preview {
    NavigationStack {
        ChatView(
            match: Match(
                id: "1",
                user1Id: "1",
                user2Id: "2",
                isActive: true,
                matchedAt: Date(),
                lastMessageAt: nil,
                profile: nil
            ),
            profile: DiscoveryProfile(
                id: "2",
                firstName: "Sarah",
                age: 28,
                photos: [],
                bio: "Adventure seeker",
                occupation: "Designer",
                school: nil,
                distanceKm: 3.5,
                compatibilityScore: 85,
                prompts: [],
                relationshipGoal: .serious,
                interests: ["Travel", "Music"],
                heightCm: 165,
                isVerified: true
            )
        )
    }
}
