import SwiftUI
import SwiftData

struct FlipDetailView: View {
    @Bindable var flip: Flip
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var showDeleteAlert = false
    @State private var showEdit = false

    var body: some View {
        ZStack {
            Color.kickBackground.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 14) {
                    shoeHeader
                    ProfitPreviewCard(purchasePrice: flip.purchasePrice, salePrice: flip.salePrice, expanded: true)
                    detailCard
                    notesCard
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle(flip.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") { showEdit = true }
                    .foregroundStyle(Color.kickAccent)
            }
            ToolbarItem(placement: .destructiveAction) {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .alert("Delete Flip?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                modelContext.delete(flip)
                try? modelContext.save()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This cannot be undone.")
        }
        .sheet(isPresented: $showEdit) {
            FlipEditSheet(flip: flip)
        }
    }

    private var shoeHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(flip.displayName)
                    .font(.system(size: 20, weight: .bold))
                HStack(spacing: 6) {
                    if !flip.colorway.isEmpty {
                        Text(flip.colorway).foregroundStyle(.secondary)
                        Text("·").foregroundStyle(.secondary)
                    }
                    Text(flip.sizeCategory.rawValue).foregroundStyle(.secondary)
                    Text("·").foregroundStyle(.secondary)
                    Text("Sz \(flip.sizeUS.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", flip.sizeUS) : String(format: "%.1f", flip.sizeUS))")
                        .foregroundStyle(.secondary)
                    Text("·").foregroundStyle(.secondary)
                    Text(flip.condition.rawValue).foregroundStyle(.secondary)
                }
                .font(.system(size: 13))
            }
            Spacer()
            statusBadge
        }
        .kickCard()
    }

    private var statusBadge: some View {
        HStack(spacing: 5) {
            Image(systemName: flip.status.icon)
                .font(.system(size: 11))
            Text(flip.status.rawValue)
                .font(.system(size: 12, weight: .semibold))
        }
        .foregroundStyle(flip.status.color)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(flip.status.color.opacity(0.15)))
    }

    private var detailCard: some View {
        VStack(spacing: 12) {
            row("Flip Date", value: flip.flipDate.formatted(date: .long, time: .omitted))
            Divider().background(Color.white.opacity(0.06))
            row("Brand", value: flip.brand)
            Divider().background(Color.white.opacity(0.06))
            row("Size Category", value: flip.sizeCategory.rawValue)
            Divider().background(Color.white.opacity(0.06))
            row("Condition", value: flip.condition.rawValue)
            if flip.status == .sold {
                Divider().background(Color.white.opacity(0.06))
                row("Profit", value: flip.profit.asSignedCurrency)
            }
        }
        .kickCard()
    }

    private var notesCard: some View {
        Group {
            if !flip.notes.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                    Text(flip.notes)
                        .font(.system(size: 15))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .kickCard()
            }
        }
    }

    private func row(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium))
        }
    }
}

// MARK: - Edit Sheet (internal so InventoryRow can use it)

struct FlipEditSheet: View {
    @Bindable var flip: Flip
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var purchaseStr: String = ""
    @State private var saleStr: String = ""
    @State private var showBrandPicker = false

    private var quickModels: [ShoeDatabase.ShoeModel] { ShoeDatabase.models(for: flip.brand) }
    private var quickColorways: [String] { ShoeDatabase.colorways(for: flip.brand, model: flip.name) }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.kickBackground.ignoresSafeArea()
                Form {
                    // Shoe Info
                    Section("Shoe Info") {
                        Button {
                            showBrandPicker = true
                        } label: {
                            HStack {
                                Text("Brand")
                                    .foregroundStyle(.primary)
                                Spacer()
                                Text(flip.brand.isEmpty ? "Select" : flip.brand)
                                    .foregroundStyle(.secondary)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                            }
                        }

                        // Model quick-picks
                        if !flip.brand.isEmpty && !quickModels.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Quick Pick Model")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 6) {
                                        ForEach(quickModels) { m in
                                            Button {
                                                flip.name = m.name
                                                flip.colorway = ""
                                            } label: {
                                                Text(m.name)
                                                    .font(.system(size: 11, weight: .medium))
                                                    .foregroundStyle(flip.name == m.name ? .black : .primary)
                                                    .lineLimit(1)
                                                    .padding(.horizontal, 10)
                                                    .padding(.vertical, 6)
                                                    .background(
                                                        flip.name == m.name ? Color.kickAccent : Color.kickSurfaceSecondary,
                                                        in: RoundedRectangle(cornerRadius: 6)
                                                    )
                                            }
                                            .buttonStyle(PressAnimationStyle())
                                        }
                                    }
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }

                        LabeledContent("Model") {
                            TextField("Shoe name", text: $flip.name)
                                .multilineTextAlignment(.trailing)
                        }

                        // Colorway quick-picks
                        if !quickColorways.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Popular Colorways")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 6) {
                                        ForEach(quickColorways, id: \.self) { cw in
                                            Button {
                                                flip.colorway = cw
                                            } label: {
                                                Text(cw)
                                                    .font(.system(size: 11, weight: .medium))
                                                    .foregroundStyle(flip.colorway == cw ? .black : .primary)
                                                    .lineLimit(1)
                                                    .padding(.horizontal, 10)
                                                    .padding(.vertical, 6)
                                                    .background(
                                                        flip.colorway == cw ? Color.kickAccent : Color.kickSurfaceSecondary,
                                                        in: RoundedRectangle(cornerRadius: 6)
                                                    )
                                            }
                                            .buttonStyle(PressAnimationStyle())
                                        }
                                    }
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }

                        LabeledContent("Colorway") {
                            TextField("Optional", text: $flip.colorway)
                                .multilineTextAlignment(.trailing)
                        }

                        Picker("Size Category", selection: $flip.sizeCategoryRaw) {
                            ForEach(SizeCategory.allCases) { cat in
                                Text(cat.rawValue).tag(cat.rawValue)
                            }
                        }

                        HStack {
                            Text("US Size")
                            Spacer()
                            Stepper(
                                value: $flip.sizeUS,
                                in: flip.sizeCategory.sizeMin...flip.sizeCategory.sizeMax,
                                step: 0.5
                            ) {
                                Text(flip.sizeUS.truncatingRemainder(dividingBy: 1) == 0
                                     ? String(format: "%.0f", flip.sizeUS)
                                     : String(format: "%.1f", flip.sizeUS))
                                    .font(.system(size: 16, weight: .semibold))
                                    .multilineTextAlignment(.trailing)
                            }
                        }

                        Picker("Condition", selection: $flip.conditionRaw) {
                            ForEach(FlipCondition.allCases) { c in
                                Text(c.rawValue).tag(c.rawValue)
                            }
                        }
                    }

                    Section("Pricing") {
                        HStack {
                            Text("Buy Price")
                            Spacer()
                            TextField("0", text: $purchaseStr)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Sell Price")
                            Spacer()
                            TextField("0", text: $saleStr)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                        }
                    }

                    Section("Status") {
                        Picker("Status", selection: $flip.statusRaw) {
                            ForEach(FlipStatus.allCases) { s in
                                Text(s.rawValue).tag(s.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    Section("Date") {
                        DatePicker("Flip Date", selection: $flip.flipDate, displayedComponents: .date)
                    }

                    Section("Notes") {
                        TextField("Platform, buyer, anything...", text: $flip.notes, axis: .vertical)
                            .lineLimit(3...6)
                    }
                }
                .scrollContentBackground(.hidden)
                .onChange(of: flip.sizeCategoryRaw) {
                    let cat = flip.sizeCategory
                    flip.sizeUS = min(max(flip.sizeUS, cat.sizeMin), cat.sizeMax)
                }
            }
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let p = Double(purchaseStr) { flip.purchasePrice = p }
                        if let s = Double(saleStr) { flip.salePrice = s }
                        try? modelContext.save()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                purchaseStr = String(Int(flip.purchasePrice))
                saleStr = String(Int(flip.salePrice))
            }
            .sheet(isPresented: $showBrandPicker) {
                BrandPickerSheet(selected: $flip.brand)
            }
        }
        .preferredColorScheme(.dark)
    }
}
