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
            row("Condition", value: flip.condition.rawValue)
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

// MARK: - Edit Sheet

private struct FlipEditSheet: View {
    @Bindable var flip: Flip
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var purchaseStr: String = ""
    @State private var saleStr: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.kickBackground.ignoresSafeArea()
                Form {
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
                        TextField("Notes...", text: $flip.notes, axis: .vertical)
                            .lineLimit(3...6)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Edit Flip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
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
        }
        .preferredColorScheme(.dark)
    }
}
