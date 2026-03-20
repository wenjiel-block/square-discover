import SwiftUI

struct OnboardingView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedCuisines: Set<Cuisine> = []

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 12) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 64))
                    .foregroundStyle(Color.brandPrimary)
                    .padding(.top, 48)

                Text("Welcome to Square Nearby")
                    .font(.title.weight(.bold))
                    .foregroundStyle(Color.brandSecondary)

                Text("What cuisines do you love?")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 32)

            // Cuisine Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(Cuisine.allCases) { cuisine in
                        CuisineChip(
                            cuisine: cuisine,
                            isSelected: selectedCuisines.contains(cuisine)
                        ) {
                            toggleCuisine(cuisine)
                        }
                    }
                }
                .padding(.horizontal, Constants.Layout.horizontalPadding)
            }

            Spacer()

            // Get Started Button
            Button {
                saveCuisinePreferences()
                appState.hasCompletedOnboarding = true
            } label: {
                Text("Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundStyle(.white)
                    .background(Color.brandPrimary, in: RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, Constants.Layout.horizontalPadding)
            .padding(.bottom, 32)
        }
    }

    private func toggleCuisine(_ cuisine: Cuisine) {
        if selectedCuisines.contains(cuisine) {
            selectedCuisines.remove(cuisine)
        } else {
            selectedCuisines.insert(cuisine)
        }
    }

    private func saveCuisinePreferences() {
        let rawValues = selectedCuisines.map(\.rawValue)
        UserDefaults.standard.set(rawValues, forKey: "preferredCuisines")
    }
}

// MARK: - Cuisine Chip

private struct CuisineChip: View {
    let cuisine: Cuisine
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(cuisine.emoji)
                    .font(.title)

                Text(cuisine.displayName)
                    .font(.caption.weight(.medium))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                isSelected ? Color.brandPrimary.opacity(0.15) : Color.surfaceSecondary,
                in: RoundedRectangle(cornerRadius: Constants.Layout.cardCornerRadius)
            )
            .overlay {
                RoundedRectangle(cornerRadius: Constants.Layout.cardCornerRadius)
                    .strokeBorder(
                        isSelected ? Color.brandPrimary : Color.clear,
                        lineWidth: 2
                    )
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OnboardingView()
        .environment(AppState())
}
