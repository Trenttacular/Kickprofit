import SwiftUI

struct PricingStepView: View {
    @Binding var purchasePrice: String
    @Binding var salePrice: String
    let onNext: () -> Void
    let onBack: () -> Void

    @State private var activeField: PriceField = .purchase

    enum PriceField { case purchase, sale }

    private var buyDouble: Double  { Double(purchasePrice) ?? 0 }
    private var sellDouble: Double { Double(salePrice) ?? 0 }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    stepHeader

                    ProfitPreviewCard(purchasePrice: buyDouble, salePrice: sellDouble)

                    // Field cards
                    VStack(spacing: 10) {
                        priceCard(
                            title: "Buy Price",
                            icon: "arrow.down.circle.fill",
                            value: purchasePrice,
                            isActive: activeField == .purchase,
                            color: .kickDanger
                        ) { activeField = .purchase }

                        priceCard(
                            title: "Sell Price",
                            icon: "arrow.up.circle.fill",
                            value: salePrice,
                            isActive: activeField == .sale,
                            color: .kickGreen
                        ) { activeField = .sale }
                    }

                    NumpadView(value: activeField == .purchase ? $purchasePrice : $salePrice)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }

            navButtons
        }
    }

    private var stepHeader: some View {
        VStack(spacing: 4) {
            Text("Pricing")
                .font(.system(size: 22, weight: .bold))
            Text("Step 2 of 3")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func priceCard(title: String, icon: String, value: String, isActive: Bool, color: Color, onTap: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(color)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                    Text(value.isEmpty ? "$0" : "$\(value)")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
                Spacer()
                if isActive {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.kickAccent)
                        .frame(width: 2, height: 24)
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.kickSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isActive ? Color.kickAccent : Color.clear, lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(PressAnimationStyle())
    }

    private var navButtons: some View {
        HStack(spacing: 12) {
            Button(action: onBack) {
                Text("Back")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.kickSurfaceSecondary, in: RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(PressAnimationStyle())

            Button(action: onNext) {
                Text("Next")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.kickAccent, in: RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(PressAnimationStyle())
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .background(Color.kickBackground)
    }
}
