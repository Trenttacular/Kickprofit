import SwiftUI

struct PaceCard: View {
    let snapshot: AnalyticsEngine.PeriodSnapshot
    let goal: Goal?

    private var projected: Double {
        AnalyticsEngine.projectedMonthEnd(earned: snapshot.totalProfit)
    }

    private var flipsNeeded: Int {
        guard let g = goal, snapshot.avgProfit > 0 else { return 0 }
        let gap = g.profitTarget - snapshot.totalProfit
        return gap > 0 ? Int(ceil(gap / snapshot.avgProfit)) : 0
    }

    private var status: (label: String, color: Color) {
        guard let g = goal, g.profitTarget > 0 else { return ("No goal set", .secondary) }
        let ratio = projected / g.profitTarget
        if ratio >= 1.0    { return ("Ahead of pace", .kickGreen) }
        if ratio >= 0.85   { return ("On pace", .kickGreen) }
        if ratio >= 0.65   { return ("Slightly behind", .kickWarning) }
        return ("Behind pace", .kickDanger)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Projected Month-End")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
                Text(projected.asCurrency)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                if flipsNeeded > 0 {
                    Text("\(flipsNeeded) more flip\(flipsNeeded == 1 ? "" : "s") to hit goal")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Text(status.label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(status.color)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Capsule().fill(status.color.opacity(0.12)))
        }
        .kickCard()
    }
}
