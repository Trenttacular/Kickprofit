import SwiftUI
import SwiftData

@main
struct KickProfitApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    let modelContainer: ModelContainer = {
        let schema = Schema([Flip.self, Goal.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("KickProfit: SwiftData failed to initialize — \(error.localizedDescription)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                RootTabView()
                    .preferredColorScheme(.dark)
            } else {
                OnboardingView(onFinish: { hasSeenOnboarding = true })
                    .preferredColorScheme(.dark)
            }
        }
        .modelContainer(modelContainer)
    }
}

// MARK: - Onboarding

private struct OnboardingView: View {
    let onFinish: () -> Void

    var body: some View {
        ZStack {
            Color.kickBackground.ignoresSafeArea()
            VStack(spacing: 32) {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "shoeprints.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(Color.kickAccent)
                    Text("KickProfit")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                    Text("Track every flip.\nKnow your profit.")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                Spacer()
                Button(action: onFinish) {
                    Text("Get Started")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.kickAccent, in: RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(PressAnimationStyle())
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
    }
}
