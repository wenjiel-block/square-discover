import Foundation

@Observable
final class ProfileViewModel {
    var profile: UserProfile?
    var userFeedItems: [FeedItem] = []
    var isLoading: Bool = false
    var error: String?

    @MainActor
    func loadProfile(userId: UUID, using userService: any UserServiceProtocol) async {
        isLoading = true
        error = nil

        do {
            profile = try await userService.fetchProfile(userId: userId)
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    @MainActor
    func loadContent(userId: UUID, using userService: any UserServiceProtocol) async {
        do {
            userFeedItems = try await userService.fetchUserContent(userId: userId, page: 1)
        } catch {
            self.error = error.localizedDescription
        }
    }
}
