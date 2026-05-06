import SwiftUI

struct HeroProfitCard: View {
    let snapshot: AnalyticsEngine.PeriodSnapshot
    let lastMonthSnapshot: AnalyticsEngine.PeriodSnapshot
    let goal: Goal?

    private var progressFraction: Double {
        guard let g = goal, g.profitTarget > 0 else { return 0 }
        return min(snapshot.totalProfit / g.profitTarget, 1.0)
    }

    private var remaining: Double {
        guard let g = goal else { return 0 }
        return max(g.profitTarget - snapshot.totalProfit, 0)
    }

    private var daysLeft: Int { AnalyticsEngine.daysLeftInMonth() }

    private var progressColor: Color {
        let timePct = 1 - (Double(daysLeft) / 30.0)
        if progressFraction >= timePct        { return .kickGreen }
        if progressFraction >= timePct - 0.15 { return .kickWarning }
        return .kickDanger
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Month Profit")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                    Text(snapshot.totalProfit.asCurrency)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(snapshot.totalProfit >= 0 ? .primary : Color.kickDanger)
                }
                Spacer()
                DeltaBadge(current: snapshot.totalProfit, previous: lastMonthSnapshot.totalProfit)
            }

            if let g = goal, g.profitTarget > 0 {
                VStack(alignment: .leading, spacing: 6) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.08))
                                .frame(height: 6)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(progressColor)
                                .frame(width: geo.size.width * progressFraction, height: 6)
                                .animation(.spring(response: 0.5), value: progressFraction)
                        }
                    }
                    .frame(height: 6)

                    HStack {
                        Text("\(remaining.asCurrency) to go")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("\(daysLeft)d left")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                }
            }

            HStack(spacing: 16) {
                StatPill(label: "\(snapshot.flipCount) flips", icon: "shoeprints.fill")
                if snapshot.flipCount > 0 {
                    StatPill(label: "avg \(snapshot.avgProfit.asCurrency)", icon: "chart.line.uptrend.xyaxis")
                }
            }
        }
        .kickCard()
    }
}
