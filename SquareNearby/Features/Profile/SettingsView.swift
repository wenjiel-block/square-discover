import SwiftUI

struct SettingsView: View {
    @Environment(\.services) private var services
    @Environment(AppState.self) private var appState
    @State private var notificationsEnabled = true
    @State private var locationEnabled = true
    @State private var showLogoutConfirmation = false

    var body: some View {
        List {
            // Account Section
            Section("Account") {
                NavigationLink {
                    // Edit profile placeholder
                    Text("Edit Profile")
                        .navigationTitle("Edit Profile")
                } label: {
                    Label("Edit Profile", systemImage: "person.crop.circle")
                }

                NavigationLink {
                    // Change password placeholder
                    Text("Change Password")
                        .navigationTitle("Change Password")
                } label: {
                    Label("Change Password", systemImage: "lock")
                }
            }

            // Preferences Section
            Section("Preferences") {
                Toggle(isOn: $notificationsEnabled) {
                    Label("Notifications", systemImage: "bell")
                }
                .tint(Color.brandPrimary)

                Toggle(isOn: $locationEnabled) {
                    Label("Location Services", systemImage: "location")
                }
                .tint(Color.brandPrimary)
            }

            // About Section
            Section("About") {
                HStack {
                    Label("Version", systemImage: "info.circle")
                    Spacer()
                    Text("1.0.0")
                        .foregroundStyle(.secondary)
                }

                NavigationLink {
                    Text("Terms of Service")
                        .navigationTitle("Terms of Service")
                } label: {
                    Label("Terms of Service", systemImage: "doc.text")
                }

                NavigationLink {
                    Text("Privacy Policy")
                        .navigationTitle("Privacy Policy")
                } label: {
                    Label("Privacy Policy", systemImage: "hand.raised")
                }
            }

            // Logout Section
            Section {
                Button(role: .destructive) {
                    showLogoutConfirmation = true
                } label: {
                    HStack {
                        Spacer()
                        Text("Log Out")
                            .font(.body.weight(.semibold))
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Are you sure you want to log out?",
            isPresented: $showLogoutConfirmation,
            titleVisibility: .visible
        ) {
            Button("Log Out", role: .destructive) {
                Task {
                    try? await services.authService.logout()
                    appState.isAuthenticated = false
                    appState.currentUser = nil
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environment(\.services, .mock)
            .environment(AppState())
    }
}
