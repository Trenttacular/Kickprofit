import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \Flip.flipDate, order: .reverse) private var allFlips: [Flip]

    @State private var selectedPeriod: AnalyticsEngine.Period = .thisMonth
    @State private var selectedStatus: FlipStatus? = nil
    @State private var searchText = ""

    private let periods: [AnalyticsEngine.Period] = [.thisMonth, .lastMonth, .last90Days, .yearToDate]

    private var filtered: [Flip] {
        let interval = selectedPeriod.dateInterval
        return allFlips.filter { flip in
            guard interval.contains(flip.flipDate) else { return false }
            if let s = selectedStatus, flip.status != s { return false }
            if !searchText.isEmpty {
                let q = searchText.lowercased()
                return flip.brand.lowercased().contains(q) || flip.name.lowercased().contains(q) || flip.colorway.lowercased().contains(q)
            }
            return true
        }
    }

    private var snapshot: AnalyticsEngine.PeriodSnapshot {
        AnalyticsEngine.PeriodSnapshot(flips: filtered)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.kickBackground.ignoresSafeArea()
                VStack(spacing: 0) {
                    filters
                    if filtered.isEmpty {
                        emptyState
                    } else {
                        summaryBar
                        flipList
                    }
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search brand or shoe")
        }
        .preferredColorScheme(.dark)
    }

    private var filters: some View {
        VStack(spacing: 10) {
            // Period chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(periods, id: \.self) { p in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedPeriod = p }
                        } label: {
                            Text(p.displayLabel)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(selectedPeriod == p ? .black : .primary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(
                                    selectedPeriod == p ? Color.kickAccent : Color.kickSurfaceSecondary,
                                    in: Capsule()
                                )
                        }
                        .buttonStyle(PressAnimationStyle())
                    }
                }
                .padding(.horizontal, 16)
            }

            // Status chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    statusChip(nil, label: "All")
                    ForEach(FlipStatus.allCases) { s in
                        statusChip(s, label: s.rawValue)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 10)
        .background(Color.kickBackground)
    }

    private func statusChip(_ status: FlipStatus?, label: String) -> some View {
        Button {
            withAnimation(.spring(response: 0.3)) { selectedStatus = status }
        } label: {
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(selectedStatus == status ? .black : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    selectedStatus == status ? Color.kickAccent : Color.kickSurfaceSecondary,
                    in: Capsule()
                )
        }
        .buttonStyle(PressAnimationStyle())
    }

    private var summaryBar: some View {
        HStack(spacing: 0) {
            summaryItem(label: "Profit", value: snapshot.totalProfit.asCurrency)
            Divider().frame(height: 30).background(Color.white.opacity(0.1))
            summaryItem(label: "Flips", value: "\(snapshot.flipCount)")
            Divider().frame(height: 30).background(Color.white.opacity(0.1))
            summaryItem(label: "Avg Profit", value: snapshot.avgProfit.asCurrency)
        }
        .padding(.vertical, 10)
        .background(Color.kickSurface)
    }

    private func summaryItem(label: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var flipList: some View {
        List {
            ForEach(filtered) { flip in
                NavigationLink(destination: FlipDetailView(flip: flip)) {
                    flipRow(flip)
                }
                .listRowBackground(Color.kickBackground)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func flipRow(_ flip: Flip) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(flip.displayName)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(1)
                HStack(spacing: 6) {
                    Text(flip.flipDate, format: .dateTime.month(.abbreviated).day().year())
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    if !flip.colorway.isEmpty {
                        Text("· \(flip.colorway)")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(flip.profit.asCurrency)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(flip.profit >= 0 ? Color.kickGreen : Color.kickDanger)
                Text(flip.status.rawValue)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(flip.status.color)
                    .padding(.horizontal, 7).padding(.vertical, 3)
                    .background(Capsule().fill(flip.status.color.opacity(0.15)))
            }
        }
        .padding(12)
        .background(Color.kickSurface, in: RoundedRectangle(cornerRadius: 14))
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundStyle(Color.kickAccent.opacity(0.4))
                .padding(.top, 60)
            Text("No flips found")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.secondary)
            Text("Try a different period or filter")
                .font(.system(size: 14))
                .foregroundStyle(.tertiary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
