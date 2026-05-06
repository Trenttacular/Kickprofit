import SwiftUI
import SwiftData

struct ReviewSaveView: View {
    let brand: String
    let name: String
    let colorway: String
    let sizeUS: Double
    let condition: FlipCondition
    let purchasePrice: Double
    let salePrice: Double
    let onSaved: (Flip) -> Void
    let onBack: () -> Void

    @Environment(\.modelContext) private var modelContext

    @State private var status: FlipStatus = .sold
    @State private var flipDate: Date = Date()
    @State private var notes: String = ""
    @State private var isSaving = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    stepHeader

                    shoeHeader

                    ProfitPreviewCard(purchasePrice: purchasePrice, salePrice: salePrice, expanded: true)

                    // Status
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Status")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.secondary)
                        HStack(spacing: 8) {
                            ForEach(FlipStatus.allCases) { s in
                                Button { status = s } label: {
                                    HStack(spacing: 6) {
                                        Image(systemName: s.icon)
                                            .font(.system(size: 12))
                                        Text(s.rawValue)
                                            .font(.system(size: 13, weight: .semibold))
                                    }
                                    .foregroundStyle(status == s ? .black : .primary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(
                                        status == s ? s.color : Color.kickSurfaceSecondary,
                                        in: RoundedRectangle(cornerRadius: 10)
                                    )
                                }
                                .buttonStyle(PressAnimationStyle())
                            }
                        }
                    }
                    .kickCard()

                    // Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Flip Date")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.secondary)
                        DatePicker("", selection: $flipDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                    .kickCard()

                    // Notes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes (optional)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.secondary)
                        TextField("Platform, buyer, anything...", text: $notes, axis: .vertical)
                            .lineLimit(3...5)
                            .textFieldStyle(KickTextFieldStyle())
                    }
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
            Text("Review & Save")
                .font(.system(size: 22, weight: .bold))
            Text("Step 3 of 3")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var shoeHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(brand) \(name)")
                    .font(.system(size: 17, weight: .bold))
                HStack(spacing: 8) {
                    if !colorway.isEmpty {
                        Text(colorway)
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                        Text("·")
                            .foregroundStyle(.secondary)
                    }
                    Text("Sz \(sizeUS.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", sizeUS) : String(format: "%.1f", sizeUS))")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    Text("·")
                        .foregroundStyle(.secondary)
                    Text(condition.rawValue)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .kickCard()
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

            Button {
                saveFlip()
            } label: {
                if isSaving {
                    ProgressView().tint(.black)
                } else {
                    Text("Save Flip")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.kickAccent, in: RoundedRectangle(cornerRadius: 14))
            .buttonStyle(PressAnimationStyle())
            .disabled(isSaving)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .background(Color.kickBackground)
    }

    private func saveFlip() {
        isSaving = true
        let flip = Flip()
        flip.brand = brand
        flip.name = name
        flip.colorway = colorway
        flip.sizeUS = sizeUS
        flip.conditionRaw = condition.rawValue
        flip.purchasePrice = purchasePrice
        flip.salePrice = salePrice
        flip.statusRaw = status.rawValue
        flip.flipDate = flipDate
        flip.notes = notes
        modelContext.insert(flip)
        try? modelContext.save()
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        isSaving = false
        onSaved(flip)
    }
}
