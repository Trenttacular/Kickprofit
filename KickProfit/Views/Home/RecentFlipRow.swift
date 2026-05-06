import SwiftUI

struct RecentFlipRow: View {
    let flip: Flip

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(flip.displayName)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(1)
                HStack(spacing: 6) {
                    Text(flip.flipDate, format: .dateTime.month(.abbreviated).day())
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    Text("·")
                        .foregroundStyle(.secondary)
                    Text("Sz \(flip.sizeUS, format: .number.precision(.fractionLength(flip.sizeUS.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 1)))")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text(flip.profit.asCurrency)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(flip.profit >= 0 ? Color.kickGreen : Color.kickDanger)
                statusBadge
            }
        }
        .kickCard(padding: 14)
    }

    private var statusBadge: some View {
        Text(flip.status.rawValue)
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(flip.status.color)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(Capsule().fill(flip.status.color.opacity(0.15)))
    }
}
