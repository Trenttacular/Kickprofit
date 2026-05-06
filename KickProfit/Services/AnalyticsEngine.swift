import Foundation

enum AnalyticsEngine {

    enum Period: Hashable {
        case today
        case thisWeek
        case thisMonth
        case lastMonth
        case last90Days
        case yearToDate
        case custom(start: Date, end: Date)

        var dateInterval: DateInterval {
            let cal = Calendar.current
            let now = Date()
            switch self {
            case .today:
                let start = cal.startOfDay(for: now)
                return DateInterval(start: start, end: now)
            case .thisWeek:
                let start = cal.dateInterval(of: .weekOfYear, for: now)?.start ?? now
                return DateInterval(start: start, end: now)
            case .thisMonth:
                let start = cal.dateInterval(of: .month, for: now)?.start ?? now
                return DateInterval(start: start, end: now)
            case .lastMonth:
                let lastMonthDate = cal.date(byAdding: .month, value: -1, to: now) ?? now
                let interval = cal.dateInterval(of: .month, for: lastMonthDate)!
                return interval
            case .last90Days:
                let start = cal.date(byAdding: .day, value: -90, to: now) ?? now
                return DateInterval(start: start, end: now)
            case .yearToDate:
                var comps = cal.dateComponents([.year], from: now)
                comps.month = 1; comps.day = 1
                let start = cal.date(from: comps) ?? now
                return DateInterval(start: start, end: now)
            case .custom(let start, let end):
                return DateInterval(start: start, end: end)
            }
        }

        var displayLabel: String {
            switch self {
            case .today:      return "Today"
            case .thisWeek:   return "This Week"
            case .thisMonth:  return "This Month"
            case .lastMonth:  return "Last Month"
            case .last90Days: return "Last 90 Days"
            case .yearToDate: return "Year to Date"
            case .custom:     return "Custom"
            }
        }
    }

    struct PeriodSnapshot {
        let flips: [Flip]

        private var soldFlips: [Flip] { flips.filter { $0.status == .sold } }

        var totalProfit: Double   { soldFlips.map(\.profit).reduce(0, +) }
        var flipCount: Int        { soldFlips.count }
        var avgProfit: Double     { flipCount > 0 ? totalProfit / Double(flipCount) : 0 }
        var avgROI: Double        { flipCount > 0 ? soldFlips.map(\.roi).reduce(0, +) / Double(flipCount) : 0 }
        var bestFlip: Flip?       { soldFlips.max { $0.profit < $1.profit } }

        var profitByBrand: [(brand: String, count: Int, totalProfit: Double)] {
            let grouped = Dictionary(grouping: soldFlips, by: \.brand)
            return grouped
                .map { (brand: $0.key, count: $0.value.count, totalProfit: $0.value.map(\.profit).reduce(0, +)) }
                .sorted { $0.totalProfit > $1.totalProfit }
        }

        var topShoes: [(name: String, count: Int, totalProfit: Double)] {
            let grouped = Dictionary(grouping: soldFlips, by: \.displayName)
            return grouped
                .map { (name: $0.key, count: $0.value.count, totalProfit: $0.value.map(\.profit).reduce(0, +)) }
                .sorted { $0.totalProfit > $1.totalProfit }
                .prefix(5)
                .map { $0 }
        }
    }

    struct MonthDataPoint: Identifiable {
        var id: Date { month }
        var month: Date
        var profit: Double
        var flipCount: Int
        var isProjected: Bool = false
    }

    static func snapshot(for period: Period, from flips: [Flip]) -> PeriodSnapshot {
        let interval = period.dateInterval
        let filtered = flips.filter { interval.contains($0.flipDate) }
        return PeriodSnapshot(flips: filtered)
    }

    static func monthlyBreakdown(from flips: [Flip], months: Int = 12) -> [MonthDataPoint] {
        let cal = Calendar.current
        let now = Date()
        var points: [MonthDataPoint] = []

        for i in stride(from: months - 1, through: 0, by: -1) {
            guard let date = cal.date(byAdding: .month, value: -i, to: now),
                  let interval = cal.dateInterval(of: .month, for: date) else { continue }

            let isCurrentMonth = cal.isDate(date, equalTo: now, toGranularity: .month)
            let monthFlips = flips.filter { $0.status == .sold && interval.contains($0.flipDate) }
            let profit = monthFlips.map(\.profit).reduce(0, +)

            points.append(MonthDataPoint(
                month: interval.start,
                profit: profit,
                flipCount: monthFlips.count,
                isProjected: isCurrentMonth
            ))
        }
        return points
    }

    static func rollingAverage(from monthly: [MonthDataPoint], window: Int = 3) -> [MonthDataPoint] {
        monthly.indices.map { i in
            let slice = monthly[max(0, i - window + 1)...i]
            let avg = slice.map(\.profit).reduce(0, +) / Double(slice.count)
            return MonthDataPoint(month: monthly[i].month, profit: avg, flipCount: monthly[i].flipCount)
        }
    }

    static func projectedMonthEnd(earned: Double) -> Double {
        let cal = Calendar.current
        let now = Date()
        guard let start = cal.dateInterval(of: .month, for: now)?.start else { return earned }
        let daysPassed = max(1, cal.dateComponents([.day], from: start, to: now).day ?? 1)
        let daysInMonth = cal.range(of: .day, in: .month, for: now)?.count ?? 30
        return (earned / Double(daysPassed)) * Double(daysInMonth)
    }

    static func daysLeftInMonth() -> Int {
        let cal = Calendar.current
        let now = Date()
        guard let end = cal.dateInterval(of: .month, for: now)?.end else { return 0 }
        return max(0, cal.dateComponents([.day], from: now, to: end).day ?? 0)
    }
}
