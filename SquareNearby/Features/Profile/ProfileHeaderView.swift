import SwiftUI

struct ProfileHeaderView: View {
    let profile: UserProfile
    let isOwnProfile: Bool
    var onEditProfile: (() -> Void)?
    var onFollow: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            // Avatar
            AvatarView(
                url: profile.avatarURL,
                initials: profile.displayName,
                size: 88
            )

            // Name and Username
            VStack(spacing: 4) {
                Text(profile.displayName)
                    .font(.title2.weight(.bold))

                Text("@\(profile.username)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // Bio
            if let bio = profile.bio, !bio.isEmpty {
                Text(bio)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 32)
            }

            // Stats Row
            HStack(spacing: 32) {
                StatItem(value: profile.formattedPostCount, label: "Posts")
                StatItem(value: profile.formattedFollowerCount, label: "Followers")
                StatItem(value: profile.formattedFollowingCount, label: "Following")
            }
            .padding(.top, 4)

            // Action Button
            if isOwnProfile {
                Button {
                    onEditProfile?()
                } label: {
                    Text("Edit Profile")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundStyle(.primary)
                        .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 8))
                }
                .padding(.horizontal, Constants.Layout.horizontalPadding)
            } else {
                PillButton(title: "Follow", systemImage: "plus") {
                    onFollow?()
                }
            }
        }
        .padding(.vertical, 20)
    }
}

// MARK: - Stat Item

private struct StatItem: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.headline)

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ProfileHeaderView(
        profile: UserProfile(
            displayName: "Jane Doe",
            username: "janedoe",
            bio: "Food enthusiast. Always exploring new flavors.",
            postCount: 42,
            followerCount: 1250,
            followingCount: 340
        ),
        isOwnProfile: true,
        onEditProfile: {},
        onFollow: {}
    )
}
