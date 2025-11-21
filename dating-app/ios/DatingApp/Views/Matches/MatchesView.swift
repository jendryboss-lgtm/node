//
//  MatchesView.swift
//  DatingApp
//
//  Matches list view
//

import SwiftUI

struct MatchesView: View {
    @EnvironmentObject var viewModel: MatchesViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // New Matches Section
                    if !viewModel.newMatches.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("New Matches")
                                .font(.headline)
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.newMatches) { match in
                                        if let profile = match.profile {
                                            NavigationLink(destination: ChatView(match: match, profile: profile)) {
                                                NewMatchCell(profile: profile)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }

                    // Conversations Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Messages")
                            .font(.headline)
                            .padding(.horizontal)

                        if viewModel.conversations.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "message")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)

                                Text("No conversations yet")
                                    .foregroundColor(.secondary)

                                Text("When you match with someone, you can start chatting here")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            LazyVStack(spacing: 0) {
                                ForEach(viewModel.conversations) { conversation in
                                    NavigationLink(destination: ChatView(match: conversation.match, profile: conversation.profile)) {
                                        ConversationCell(conversation: conversation)
                                    }
                                    Divider()
                                        .padding(.leading, 80)
                                }
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Matches")
            .refreshable {
                await viewModel.fetchMatches()
            }
            .task {
                await viewModel.fetchMatches()
            }
        }
    }
}

// MARK: - New Match Cell
struct NewMatchCell: View {
    let profile: DiscoveryProfile

    var body: some View {
        VStack {
            // Profile photo
            if let photoUrl = profile.primaryPhotoUrl {
                AsyncImage(url: URL(string: photoUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.pink, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
            }

            Text(profile.firstName)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
    }
}

// MARK: - Conversation Cell
struct ConversationCell: View {
    let conversation: Conversation

    var body: some View {
        HStack(spacing: 12) {
            // Profile photo
            if let photoUrl = conversation.profile.primaryPhotoUrl {
                AsyncImage(url: URL(string: photoUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            }

            // Message preview
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(conversation.displayName)
                        .font(.headline)

                    Spacer()

                    Text(conversation.timeAgo)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text(conversation.lastMessagePreview)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            // Unread indicator
            if conversation.unreadCount > 0 {
                Circle()
                    .fill(Color.pink)
                    .frame(width: 12, height: 12)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

#Preview {
    MatchesView()
        .environmentObject(MatchesViewModel())
}
