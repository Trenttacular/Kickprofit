import SwiftUI

struct ProfitPreviewCard: View {
    let purchasePrice: Double
    let salePrice: Double
    var expanded: Bool = false

    private var profit: Double { salePrice - purchasePrice }
    private var roi: Double { purchasePrice > 0 ? profit / purchasePrice : 0 }
    private var isPositive: Bool { profit >= 0 }

    var body: some View {
        if expanded {
            expandedCard
        } else {
            compactCard
        }
    }

    private var compactCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Live Profit")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.secondary)
                Text(profit.asCurrency)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(isPositive ? Color.kickGreen : Color.kickDanger)
            }
            Spacer()
            if purchasePrice > 0 {
                Text(roi.asROI)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(isPositive ? Color.kickGreen : Color.kickDanger)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().fill((isPositive ? Color.kickGreen : Color.kickDanger).opacity(0.12)))
            }
        }
        .kickCard(padding: 14)
    }

    private var expandedCard: some View {
        VStack(spacing: 14) {
            VStack(spacing: 4) {
                Text("Profit")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
                Text(profit.asCurrency)
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundStyle(isPositive ? Color.kickGreen : Color.kickDanger)
                if purchasePrice > 0 {
                    Text(roi.asROI + " ROI")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(isPositive ? Color.kickGreen : Color.kickDanger)
                }
            }

            Divider().background(Color.white.opacity(0.08))

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Bought")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    Text(purchasePrice.asCurrency)
                        .font(.system(size: 16, weight: .semibold))
                }
                Spacer()
                Image(systemName: "arrow.right")
                    .foregroundStyle(.secondary)
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Sold")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    Text(salePrice.asCurrency)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
        .kickCard()
    }
}
