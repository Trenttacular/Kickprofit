import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query(sort: \Flip.flipDate, order: .reverse) private var allFlips: [Flip]
    @Query private var goals: [Goal]
    @Environment(\.modelContext) private var modelContext

    @State private var showGoalEditor = false
    @State private var showExport = false
    @State private var csvString = ""

    private var currentGoal: Goal? {
        goals.first { $0.monthYear == Goal.monthYearKey() }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.kickBackground.ignoresSafeArea()
                List {
                    goalSection
                    exportSection
                    aboutSection
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showGoalEditor) {
            GoalEditorSheet(existing: currentGoal) { profit, flips in
                let key = Goal.monthYearKey()
                if let existing = currentGoal {
                    existing.profitTarget = profit
                    existing.flipCountTarget = flips
                } else {
                    modelContext.insert(Goal(monthYear: key, profitTarget: profit, flipCountTarget: flips))
                }
                try? modelContext.save()
                showGoalEditor = false
            }
        }
        .sheet(isPresented: $showExport) {
            ShareLink(
                item: csvString,
                subject: Text("KickProfit Export"),
                message: Text("My flip history from KickProfit")
            )
        }
    }

    private var goalSection: some View {
        Section {
            if let goal = currentGoal {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Profit Goal")
                            .font(.system(size: 15))
                        Text("\(goal.profitTarget.asCurrency) · \(goal.flipCountTarget) flips")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button("Edit") { showGoalEditor = true }
                        .foregroundStyle(Color.kickAccent)
                        .font(.system(size: 14, weight: .medium))
                }
            } else {
                Button {
                    showGoalEditor = true
                } label: {
                    Label("Set Monthly Goal", systemImage: "target")
                        .foregroundStyle(Color.kickAccent)
                }
            }
        } header: {
            Text("Monthly Goal")
        } footer: {
            Text("Goals reset each month.")
        }
    }

    private var exportSection: some View {
        Section("Export") {
            Button {
                csvString = generateCSV()
                showExport = true
            } label: {
                Label("Export All Flips as CSV", systemImage: "square.and.arrow.up")
                    .foregroundStyle(Color.kickAccent)
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("App")
                Spacer()
                Text("KickProfit")
                    .foregroundStyle(.secondary)
            }
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0")
                    .foregroundStyle(.secondary)
            }
            HStack {
                Text("Built with")
                Spacer()
                Text("SwiftUI + SwiftData")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func generateCSV() -> String {
        var rows = ["Date,Brand,Name,Colorway,Size,Condition,BuyPrice,SellPrice,Profit,ROI,Status,Notes"]
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        for flip in allFlips {
            let roi = flip.purchasePrice > 0
                ? String(format: "%.1f%%", flip.roi * 100)
                : "N/A"
            let size = flip.sizeUS.truncatingRemainder(dividingBy: 1) == 0
                ? String(format: "%.0f", flip.sizeUS)
                : String(format: "%.1f", flip.sizeUS)
            rows.append([
                formatter.string(from: flip.flipDate),
                flip.brand,
                "\"\(flip.name)\"",
                flip.colorway,
                size,
                flip.condition.rawValue,
                String(format: "%.2f", flip.purchasePrice),
                String(format: "%.2f", flip.salePrice),
                String(format: "%.2f", flip.profit),
                roi,
                flip.status.rawValue,
                "\"\(flip.notes)\""
            ].joined(separator: ","))
        }
        return rows.joined(separator: "\n")
    }
}

// MARK: - Goal Editor

private struct GoalEditorSheet: View {
    let existing: Goal?
    let onSave: (Double, Int) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var profitStr: String = ""
    @State private var flipCount: Int = 10

    var body: some View {
        NavigationStack {
            ZStack {
                Color.kickBackground.ignoresSafeArea()
                Form {
                    Section("Monthly Profit Target") {
                        HStack {
                            Text("$")
                                .foregroundStyle(.secondary)
                            TextField("1000", text: $profitStr)
                                .keyboardType(.numberPad)
                        }
                    }
                    Section("Flip Count Target") {
                        Stepper("\(flipCount) flips", value: $flipCount, in: 1...500)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(existing == nil ? "Set Goal" : "Edit Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(Double(profitStr) ?? 0, flipCount)
                    }
                    .fontWeight(.semibold)
                    .disabled(profitStr.isEmpty)
                }
            }
            .onAppear {
                if let g = existing {
                    profitStr = String(Int(g.profitTarget))
                    flipCount = g.flipCountTarget
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
