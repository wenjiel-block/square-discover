import Foundation

@Observable
final class AppState {
    var isAuthenticated: Bool = false
    var currentUser: User?
    var activeOrder: Order?
    var unreadNotificationCount: Int = 0

    var hasCompletedOnboarding: Bool {
        get {
            UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "hasCompletedOnboarding")
        }
    }
}
