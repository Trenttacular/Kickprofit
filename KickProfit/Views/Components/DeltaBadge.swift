import SwiftUI

struct DeltaBadge: View {
    let current: Double
    let previous: Double

    private var percent: Double {
        guard previous > 0 else { return 0 }
        return ((current - previous) / previous) * 100
    }
    private var isPositive: Bool { percent >= 0 }

    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                .font(.system(size: 10, weight: .bold))
            Text("\(abs(percent), format: .number.precision(.fractionLength(0)))%")
                .font(.system(size: 12, weight: .bold))
        }
        .foregroundStyle(isPositive ? Color.kickGreen : Color.kickDanger)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Capsule().fill((isPositive ? Color.kickGreen : Color.kickDanger).opacity(0.15)))
    }
}
