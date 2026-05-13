import SwiftUI
import SwiftData

struct HomeView: View {
    let onLogFlip: () -> Void

    @Query(sort: \Flip.flipDate, order: .reverse) private var allFlips: [Flip]
    @Query private var goals: [Goal]

    private var monthSnapshot: AnalyticsEngine.PeriodSnapshot {
        AnalyticsEngine.snapshot(for: .thisMonth, from: allFlips)
    }
    private var lastMonthSnapshot: AnalyticsEngine.PeriodSnapshot {
        AnalyticsEngine.snapshot(for: .lastMonth, from: allFlips)
    }
    private var todaySnapshot: AnalyticsEngine.PeriodSnapshot {
        AnalyticsEngine.snapshot(for: .today, from: allFlips)
    }
    private var weekSnapshot: AnalyticsEngine.PeriodSnapshot {
        AnalyticsEngine.snapshot(for: .thisWeek, from: allFlips)
    }
    private var currentGoal: Goal? {
        goals.first { $0.monthYear == Goal.monthYearKey() }
    }
    private var recentFlips: [Flip] {
        Array(allFlips.filter { $0.status == .sold }.prefix(5))
    }
    private var inventoryFlips: [Flip] {
        allFlips.filter { $0.status == .listed }.sorted { $0.createdAt < $1.createdAt }
    }

    // Net cash flow: sold revenue minus inventory cost (uses Flip.cashFlowValue)
    private var netValue: Double {
        allFlips.reduce(0) { $0 + $1.cashFlowValue }
    }
    private var listedTotal: Double {
        allFlips.filter { $0.status == .listed }.map(\.purchasePrice).reduce(0, +)
    }
    private var soldTotal: Double {
        allFlips.filter { $0.status == .sold }.map(\.salePrice).reduce(0, +)
    }

    private var greeting: String {
        let h = Calendar.current.component(.hour, from: Date())
        if h < 12 { return "Good morning" }
        if h < 17 { return "Good afternoon" }
        return "Good evening"
    }

    var body: some View {
        ZStack {
            Color.kickBackground.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 14) {
                    header
                    if !allFlips.isEmpty {
                        netGainLossCard
                    }
                    HeroProfitCard(
                        snapshot: monthSnapshot,
                        lastMonthSnapshot: lastMonthSnapshot,
                        goal: currentGoal
                    )
                    miniStats
                    if allFlips.contains(where: { $0.status == .sold }) {
                        PaceCard(snapshot: monthSnapshot, goal: currentGoal)
                    }
                    if !inventoryFlips.isEmpty {
                        inventorySection
                    }
                    if !recentFlips.isEmpty {
                        recentSection
                    } else if inventoryFlips.isEmpty {
                        emptyState
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(greeting)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                Text(Date(), format: .dateTime.weekday(.wide).month(.wide).day())
                    .font(.system(size: 20, weight: .bold))
            }
            Spacer()
            Image(systemName: "shoeprints.fill")
                .font(.system(size: 22))
                .foregroundStyle(Color.kickAccent)
        }
        .padding(.top, 8)
    }

    private var netGainLossCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Net Gain / Loss")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("All Time")
                    .font(.system(size: 11))
                    .foregroundStyle(.tertiary)
            }

            Text(netValue.asSignedCurrency)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(netValue >= 0 ? Color.kickGreen : Color.kickDanger)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.4), value: netValue)

            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("In Stock")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    Text(listedTotal > 0 ? "-\(listedTotal.asCurrency)" : "$0")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(listedTotal > 0 ? Color.kickDanger : .secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Sold Revenue")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    Text(soldTotal > 0 ? soldTotal.asSignedCurrency : "$0")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(soldTotal > 0 ? Color.kickGreen : .secondary)
                }
            }
        }
        .kickCard()
    }

    private var miniStats: some View {
        HStack(spacing: 10) {
            MiniStatCard(
                title: "Today",
                value: todaySnapshot.totalProfit.asCurrency,
                subtitle: "\(todaySnapshot.flipCount) flips",
                valueColor: todaySnapshot.totalProfit >= 0 ? .kickGreen : .kickDanger
            )
            MiniStatCard(
                title: "This Week",
                value: weekSnapshot.totalProfit.asCurrency,
                subtitle: "\(weekSnapshot.flipCount) flips",
                trendUp: weekSnapshot.totalProfit >= lastMonthSnapshot.totalProfit / 4,
                valueColor: weekSnapshot.totalProfit >= 0 ? .kickGreen : .kickDanger
            )
            MiniStatCard(
                title: "Avg ROI",
                value: monthSnapshot.avgROI.asROI,
                subtitle: "this month",
                valueColor: monthSnapshot.avgROI >= 0 ? .kickGreen : .kickDanger
            )
        }
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Flips")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.secondary)
                .padding(.leading, 2)
            ForEach(recentFlips) { flip in
                RecentFlipRow(flip: flip)
            }
        }
    }

    private var inventorySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("In Stock")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(inventoryFlips.count) pair\(inventoryFlips.count == 1 ? "" : "s")")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
            .padding(.leading, 2)
            ForEach(inventoryFlips) { flip in
                InventoryRow(flip: flip)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "shoeprints.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.kickAccent.opacity(0.4))
            Text("No flips logged yet")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.secondary)
            Text("Tap + to list your first shoe")
                .font(.system(size: 14))
                .foregroundStyle(.tertiary)
            Button(action: onLogFlip) {
                Text("Add a Shoe")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.kickAccent, in: RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(PressAnimationStyle())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}
