import SwiftUI

struct InventoryRow: View {
    let flip: Flip
    @State private var showEdit = false

    private var daysHeld: Int {
        Calendar.current.dateComponents([.day], from: flip.createdAt, to: Date()).day ?? 0
    }

    var body: some View {
        Button { showEdit = true } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(flip.displayName)
                        .font(.system(size: 15, weight: .semibold))
                        .lineLimit(1)
                    HStack(spacing: 6) {
                        if !flip.colorway.isEmpty {
                            Text(flip.colorway)
                                .foregroundStyle(.secondary)
                            Text("·").foregroundStyle(.secondary)
                        }
                        Text(flip.sizeCategory.rawValue)
                            .foregroundStyle(.secondary)
                        Text("·").foregroundStyle(.secondary)
                        Text("Sz \(flip.sizeUS.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", flip.sizeUS) : String(format: "%.1f", flip.sizeUS))")
                            .foregroundStyle(.secondary)
                        Text("·").foregroundStyle(.secondary)
                        Text(flip.condition.rawValue)
                            .foregroundStyle(.secondary)
                    }
                    .font(.system(size: 12))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    // Show negative value (money tied up)
                    Text((-flip.purchasePrice).asCurrency)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.kickDanger)
                    HStack(spacing: 4) {
                        Text("\(daysHeld)d in stock")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                        Image(systemName: "pencil")
                            .font(.system(size: 10))
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            .kickCard(padding: 14)
        }
        .buttonStyle(PressAnimationStyle())
        .sheet(isPresented: $showEdit) {
            FlipEditSheet(flip: flip)
        }
    }
}
