import SwiftUI

struct RootTabView: View {
    @State private var selectedTab = 0
    @State private var showLogFlip = false

    private let tabs: [(icon: String, label: String)] = [
        ("house.fill",     "Home"),
        ("clock.fill",     "History"),
        ("chart.bar.fill", "Reports"),
        ("gearshape.fill", "Settings"),
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView(onLogFlip: { showLogFlip = true })
                    .tag(0)
                HistoryView()
                    .tag(1)
                ReportsView()
                    .tag(2)
                SettingsView()
                    .tag(3)
            }
            .toolbar(.hidden, for: .tabBar)

            customTabBar
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showLogFlip) {
            QuickLogFlipView()
        }
    }

    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { i in
                if i == 2 {
                    // FAB placeholder
                    Spacer().frame(width: 72)
                }
                tabButton(index: i)
            }
        }
        .frame(height: 56)
        .background(
            Color.kickSurface
                .overlay(Rectangle().frame(height: 0.5).foregroundStyle(Color.white.opacity(0.08)), alignment: .top)
        )
        .overlay(alignment: .top) {
            // Center FAB
            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                showLogFlip = true
            } label: {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Color.kickAccentLight, Color.kickAccent], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 58, height: 58)
                        .shadow(color: Color.kickAccent.opacity(0.5), radius: 8, y: 4)
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .buttonStyle(PressAnimationStyle())
            .offset(y: -16)
        }
    }

    private func tabButton(index: Int) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = index
            }
        } label: {
            VStack(spacing: 3) {
                Image(systemName: tabs[index].icon)
                    .font(.system(size: 20))
                    .foregroundStyle(selectedTab == index ? Color.kickAccent : .secondary)
                Text(tabs[index].label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(selectedTab == index ? Color.kickAccent : .secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PressAnimationStyle())
    }
}
