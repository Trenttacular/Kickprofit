import SwiftData
import Foundation

@Model
final class Goal {
    var id: UUID = UUID()
    var monthYear: String = ""
    var profitTarget: Double = 1_000
    var flipCountTarget: Int = 10

    init(monthYear: String, profitTarget: Double, flipCountTarget: Int) {
        self.monthYear = monthYear
        self.profitTarget = profitTarget
        self.flipCountTarget = flipCountTarget
    }

    static func monthYearKey(for date: Date = Date()) -> String {
        let cal = Calendar.current
        let year = cal.component(.year, from: date)
        let month = cal.component(.month, from: date)
        return String(format: "%04d-%02d", year, month)
    }
}
