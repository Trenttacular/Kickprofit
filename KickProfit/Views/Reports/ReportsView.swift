import SwiftUI
import SwiftData
import Charts

struct ReportsView: View {
    @Query(sort: \Flip.flipDate, order: .reverse) private var allFlips: [Flip]

    @State private var selectedPeriod: AnalyticsEngine.Period = .thisMonth

    private let periods: [AnalyticsEngine.Period] = [.thisMonth, .last90Days, .yearToDate]

    private var snapshot: AnalyticsEngine.PeriodSnapshot {
        AnalyticsEngine.snapshot(for: selectedPeriod, from: allFlips)
    }
    private var monthly: [AnalyticsEngine.MonthDataPoint] {
        AnalyticsEngine.monthlyBreakdown(from: allFlips, months: 12)
    }
    private var rollingAvg: [AnalyticsEngine.MonthDataPoint] {
        AnalyticsEngine.rollingAverage(from: monthly, window: 3)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.kickBackground.ignoresSafeArea()
                if allFlips.filter({ $0.status == .sold }).isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            periodPicker
                            statCards
                            trendChart
                            barChart
                            if snapshot.profitByBrand.count > 1 {
                                brandDonut
                            }
                            topShoesList
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Reports")
            .navigationBarTitleDisplayMode(.large)
        }
        .preferredColorScheme(.dark)
    }

    private var periodPicker: some View {
        HStack(spacing: 8) {
            ForEach(periods, id: \.self) { p in
                Button {
                    withAnimation(.spring(response: 0.3)) { selectedPeriod = p }
                } label: {
                    Text(p.displayLabel)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(selectedPeriod == p ? .black : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            selectedPeriod == p ? Color.kickAccent : Color.kickSurfaceSecondary,
                            in: Capsule()
                        )
                }
                .buttonStyle(PressAnimationStyle())
            }
        }
    }

    private var statCards: some View {
        HStack(spacing: 10) {
            MiniStatCard(
                title: "Total Profit",
                value: snapshot.totalProfit.asCurrency,
                subtitle: "\(snapshot.flipCount) sold",
                valueColor: snapshot.totalProfit >= 0 ? .kickGreen : .kickDanger
            )
            MiniStatCard(
                title: "Flips",
                value: "\(snapshot.flipCount)",
                subtitle: "sold"
            )
            MiniStatCard(
                title: "Avg Profit",
                value: snapshot.avgProfit.asCurrency,
                subtitle: "per flip",
                valueColor: snapshot.avgProfit >= 0 ? .kickGreen : .kickDanger
            )
        }
    }

    private var trendChart: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("12-Month Profit Trend")
                .font(.system(size: 15, weight: .semibold))

            Chart {
                ForEach(monthly) { point in
                    AreaMark(
                        x: .value("Month", point.month, unit: .month),
                        y: .value("Profit", point.profit)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.kickAccent.opacity(0.3), Color.kickAccent.opacity(0.0)],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.catmullRom)

                    LineMark(
                        x: .value("Month", point.month, unit: .month),
                        y: .value("Profit", point.profit)
                    )
                    .foregroundStyle(point.isProjected ? Color.kickAccent.opacity(0.5) : Color.kickAccent)
                    .lineStyle(StrokeStyle(lineWidth: 2.5, dash: point.isProjected ? [5, 4] : []))
                    .interpolationMethod(.catmullRom)
                }

                ForEach(rollingAvg) { point in
                    LineMark(
                        x: .value("Month", point.month, unit: .month),
                        y: .value("Avg", point.profit)
                    )
                    .foregroundStyle(Color.kickWarning.opacity(0.7))
                    .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
                    .interpolationMethod(.catmullRom)
                }
            }
            .chartYAxis {
                AxisMarks(format: .currency(code: "USD").precision(.fractionLength(0)))
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month, count: 2)) { _ in
                    AxisValueLabel(format: .dateTime.month(.abbreviated))
                }
            }
            .frame(height: 200)

            HStack(spacing: 16) {
                legendItem(color: .kickAccent, label: "Profit")
                legendItem(color: .kickWarning, label: "3-mo avg", dashed: true)
            }
        }
        .kickCard()
    }

    private var barChart: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Monthly Breakdown")
                .font(.system(size: 15, weight: .semibold))

            Chart(monthly) { point in
                BarMark(
                    x: .value("Month", point.month, unit: .month),
                    y: .value("Profit", point.profit)
                )
                .foregroundStyle(
                    point.isProjected
                    ? AnyShapeStyle(Color.kickWarning.opacity(0.5))
                    : AnyShapeStyle(LinearGradient(colors: [Color.kickAccentLight, Color.kickAccent], startPoint: .top, endPoint: .bottom))
                )
                .cornerRadius(4)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month, count: 2)) { _ in
                    AxisValueLabel(format: .dateTime.month(.abbreviated))
                }
            }
            .chartYAxis {
                AxisMarks(format: .currency(code: "USD").precision(.fractionLength(0)))
            }
            .frame(height: 180)
        }
        .kickCard()
    }

    private var brandDonut: some View {
        let brands = snapshot.profitByBrand
        let topBrands = Array(brands.prefix(4))
        let otherProfit = brands.dropFirst(4).map(\.totalProfit).reduce(0, +)

        return VStack(alignment: .leading, spacing: 14) {
            Text("Profit by Brand")
                .font(.system(size: 15, weight: .semibold))

            HStack(alignment: .center, spacing: 20) {
                Chart {
                    ForEach(Array(topBrands.enumerated()), id: \.offset) { i, item in
                        SectorMark(angle: .value("Profit", item.totalProfit), innerRadius: .ratio(0.6))
                            .foregroundStyle(brandColor(i))
                    }
                    if otherProfit > 0 {
                        SectorMark(angle: .value("Profit", otherProfit), innerRadius: .ratio(0.6))
                            .foregroundStyle(Color.kickSurfaceSecondary)
                    }
                }
                .frame(width: 130, height: 130)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(topBrands.enumerated()), id: \.offset) { i, item in
                        HStack(spacing: 8) {
                            Circle().fill(brandColor(i)).frame(width: 8, height: 8)
                            Text(item.brand)
                                .font(.system(size: 13))
                            Spacer()
                            Text(item.totalProfit.asCurrency)
                                .font(.system(size: 13, weight: .semibold))
                        }
                    }
                    if otherProfit > 0 {
                        HStack(spacing: 8) {
                            Circle().fill(Color.kickSurfaceSecondary).frame(width: 8, height: 8)
                            Text("Other")
                                .font(.system(size: 13))
                            Spacer()
                            Text(otherProfit.asCurrency)
                                .font(.system(size: 13, weight: .semibold))
                        }
                    }
                }
            }
        }
        .kickCard()
    }

    private func brandColor(_ i: Int) -> Color {
        [Color.kickAccent, Color.kickWarning, Color.kickGreen, Color.kickAccentLight][i % 4]
    }

    private var topShoesList: some View {
        let top = snapshot.topShoes
        guard !top.isEmpty else { return AnyView(EmptyView()) }

        return AnyView(
            VStack(alignment: .leading, spacing: 12) {
                Text("Top Shoes by Profit")
                    .font(.system(size: 15, weight: .semibold))

                ForEach(Array(top.enumerated()), id: \.offset) { i, item in
                    HStack(spacing: 12) {
                        Text("\(i + 1)")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(.secondary)
                            .frame(width: 20)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.name)
                                .font(.system(size: 14, weight: .semibold))
                                .lineLimit(1)
                            Text("\(item.count) flip\(item.count == 1 ? "" : "s")")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(item.totalProfit.asCurrency)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.kickGreen)
                    }
                    if i < top.count - 1 {
                        Divider().background(Color.white.opacity(0.06))
                    }
                }
            }
            .kickCard()
        )
    }

    private func legendItem(color: Color, label: String, dashed: Bool = false) -> some View {
        HStack(spacing: 6) {
            if dashed {
                HStack(spacing: 2) {
                    ForEach(0..<3, id: \.self) { _ in
                        Rectangle().fill(color).frame(width: 5, height: 2)
                        Rectangle().fill(Color.clear).frame(width: 2, height: 2)
                    }
                }
                .frame(width: 20)
            } else {
                Rectangle().fill(color).frame(width: 20, height: 2)
            }
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 48))
                .foregroundStyle(Color.kickAccent.opacity(0.4))
            Text("No data yet")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.secondary)
            Text("Log your first sold flip to see reports")
                .font(.system(size: 14))
                .foregroundStyle(.tertiary)
        }
    }
}
