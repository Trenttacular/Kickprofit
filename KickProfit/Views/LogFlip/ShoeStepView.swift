import SwiftUI

struct ShoeStepView: View {
    @Binding var brand: String
    @Binding var name: String
    @Binding var colorway: String
    @Binding var sizeUS: Double
    @Binding var condition: FlipCondition
    let onNext: () -> Void

    @State private var showBrandPicker = false

    private let popularBrands = [
        "Nike","Jordan","Adidas","New Balance","Yeezy","Puma",
        "Reebok","Saucony","Converse","Vans","ASICS","On Running",
        "Salehe Bembury","New Balance Collab","Travis Scott","Off-White",
        "Fear of God","Union","Concepts","Kith","Supreme","Virgil Abloh",
        "Air Max","Dunk","Air Force 1","Other",
    ]

    private var canProceed: Bool { !brand.isEmpty && !name.isEmpty }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    stepHeader

                    // Brand
                    VStack(alignment: .leading, spacing: 8) {
                        fieldLabel("Brand")
                        Button {
                            showBrandPicker = true
                        } label: {
                            HStack {
                                Text(brand.isEmpty ? "Select brand" : brand)
                                    .foregroundStyle(brand.isEmpty ? .secondary : .primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(Color.kickSurfaceSecondary, in: RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PressAnimationStyle())
                    }

                    // Name
                    VStack(alignment: .leading, spacing: 8) {
                        fieldLabel("Shoe Name")
                        TextField("e.g. Air Jordan 1 Retro High OG", text: $name)
                            .textFieldStyle(KickTextFieldStyle())
                    }

                    // Colorway
                    VStack(alignment: .leading, spacing: 8) {
                        fieldLabel("Colorway (optional)")
                        TextField("e.g. Chicago", text: $colorway)
                            .textFieldStyle(KickTextFieldStyle())
                    }

                    // Size
                    VStack(alignment: .leading, spacing: 8) {
                        fieldLabel("US Size")
                        HStack(spacing: 16) {
                            Button {
                                if sizeUS > 5 { sizeUS -= 0.5 }
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(Color.kickAccent)
                            }
                            .buttonStyle(PressAnimationStyle())

                            Text(sizeUS.truncatingRemainder(dividingBy: 1) == 0
                                 ? String(format: "%.0f", sizeUS)
                                 : String(format: "%.1f", sizeUS))
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .frame(minWidth: 60)

                            Button {
                                if sizeUS < 18 { sizeUS += 0.5 }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(Color.kickAccent)
                            }
                            .buttonStyle(PressAnimationStyle())
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.kickSurfaceSecondary, in: RoundedRectangle(cornerRadius: 12))
                    }

                    // Condition
                    VStack(alignment: .leading, spacing: 8) {
                        fieldLabel("Condition")
                        HStack(spacing: 8) {
                            ForEach(FlipCondition.allCases) { cond in
                                Button {
                                    condition = cond
                                } label: {
                                    Text(cond.rawValue)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(condition == cond ? .black : .primary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(
                                            condition == cond
                                            ? Color.kickAccent
                                            : Color.kickSurfaceSecondary,
                                            in: RoundedRectangle(cornerRadius: 10)
                                        )
                                }
                                .buttonStyle(PressAnimationStyle())
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }

            nextButton
        }
        .sheet(isPresented: $showBrandPicker) {
            BrandPickerSheet(selected: $brand)
        }
    }

    private var stepHeader: some View {
        VStack(spacing: 4) {
            Text("Shoe Info")
                .font(.system(size: 22, weight: .bold))
            Text("Step 1 of 3")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(.secondary)
    }

    private var nextButton: some View {
        Button(action: onNext) {
            Text("Next")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(canProceed ? .black : .secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(canProceed ? Color.kickAccent : Color.kickSurfaceSecondary, in: RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(PressAnimationStyle())
        .disabled(!canProceed)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .background(Color.kickBackground)
    }
}

// MARK: - Brand Picker

private struct BrandPickerSheet: View {
    @Binding var selected: String
    @Environment(\.dismiss) private var dismiss

    private let brands = [
        "Nike","Jordan","Adidas","New Balance","Yeezy","Puma",
        "Reebok","Saucony","Converse","Vans","ASICS","On Running",
        "Salehe Bembury","Travis Scott","Off-White","Fear of God",
        "Union","Concepts","Kith","Supreme","Other",
    ]

    var body: some View {
        NavigationStack {
            List(brands, id: \.self) { brand in
                Button {
                    selected = brand
                    dismiss()
                } label: {
                    HStack {
                        Text(brand)
                            .foregroundStyle(.primary)
                        Spacer()
                        if selected == brand {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.kickAccent)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Select Brand")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Text Field Style

struct KickTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding()
            .background(Color.kickSurfaceSecondary, in: RoundedRectangle(cornerRadius: 12))
    }
}
