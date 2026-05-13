import SwiftUI

struct QuickLogFlipView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var currentStep = 0
    @State private var savedFlip: Flip? = nil
    @State private var showSuccess = false

    // Step 0 — Shoe
    @State private var brand: String = ""
    @State private var name: String = ""
    @State private var colorway: String = ""
    @State private var sizeUS: Double = 10.0
    @State private var sizeCategory: SizeCategory = .mens
    @State private var condition: FlipCondition = .deadstock

    // Step 1 — Pricing
    @State private var purchasePrice: String = ""
    @State private var salePrice: String = ""

    var body: some View {
        ZStack {
            Color.kickBackground.ignoresSafeArea()

            if showSuccess, let flip = savedFlip {
                successOverlay(flip: flip)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            } else {
                VStack(spacing: 0) {
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 36, height: 4)
                        .padding(.top, 12)
                        .padding(.bottom, 4)

                    stepProgress

                    stepContent
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal:   .move(edge: .leading).combined(with: .opacity)
                        ))
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var stepProgress: some View {
        HStack(spacing: 6) {
            ForEach(0..<3, id: \.self) { i in
                Capsule()
                    .fill(i <= currentStep ? Color.kickAccent : Color.kickSurfaceSecondary)
                    .frame(height: 4)
                    .animation(.spring(response: 0.3), value: currentStep)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }

    @ViewBuilder
    private var stepContent: some View {
        switch currentStep {
        case 0:
            ShoeStepView(
                brand: $brand, name: $name, colorway: $colorway,
                sizeUS: $sizeUS, sizeCategory: $sizeCategory, condition: $condition
            ) {
                withAnimation(.spring(response: 0.35)) { currentStep = 1 }
            }
        case 1:
            PricingStepView(
                purchasePrice: $purchasePrice,
                salePrice: $salePrice,
                onNext: { withAnimation(.spring(response: 0.35)) { currentStep = 2 } },
                onBack: { withAnimation(.spring(response: 0.35)) { currentStep = 0 } }
            )
        default:
            ReviewSaveView(
                brand: brand, name: name, colorway: colorway,
                sizeUS: sizeUS, sizeCategory: sizeCategory, condition: condition,
                purchasePrice: Double(purchasePrice) ?? 0,
                salePrice: Double(salePrice) ?? 0,
                onSaved: { flip in
                    savedFlip = flip
                    withAnimation(.spring(response: 0.4)) { showSuccess = true }
                },
                onBack: { withAnimation(.spring(response: 0.35)) { currentStep = 1 } }
            )
        }
    }

    private func successOverlay(flip: Flip) -> some View {
        ZStack {
            ConfettiView().ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.kickGreen.opacity(0.15))
                            .frame(width: 80, height: 80)
                        Image(systemName: flip.status == .listed ? "tag.fill" : "checkmark.circle.fill")
                            .font(.system(size: 52))
                            .foregroundStyle(flip.status == .listed ? Color.kickAccent : Color.kickGreen)
                    }
                    Text(flip.status == .listed ? "Shoe Listed!" : "Flip Logged!")
                        .font(.system(size: 28, weight: .bold))
                    Text(flip.displayName)
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                }

                ProfitPreviewCard(
                    purchasePrice: flip.purchasePrice,
                    salePrice: flip.salePrice,
                    expanded: true
                )
                .padding(.horizontal, 24)

                Spacer()

                VStack(spacing: 10) {
                    Button {
                        resetForm()
                        withAnimation { showSuccess = false }
                    } label: {
                        Text("Add Another")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.kickSurfaceSecondary, in: RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(PressAnimationStyle())

                    Button { dismiss() } label: {
                        Text("Done")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.kickAccent, in: RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(PressAnimationStyle())
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }

    private func resetForm() {
        currentStep = 0
        brand = ""; name = ""; colorway = ""
        sizeUS = 10.0; sizeCategory = .mens; condition = .deadstock
        purchasePrice = ""; salePrice = ""
        savedFlip = nil
    }
}
